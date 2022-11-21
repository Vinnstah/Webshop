import Foundation
import ComposableArchitecture
import Logging
import PostgresNIO
import NIOPosix
import Vapor
import XCTestDynamicOverlay
import DatabaseCartClient
import Database

extension DatabaseCartClient: DependencyKey {
    
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(
           createCartSession: { db, cart in
               try await database.createCartSession(db, from: cart, logger: database.logger)
                
            }, getAllItemsInCart: { db, session in
                try await database.getAllItemsInCart(from: session, db, logger: database.logger)
                
            }, fetchCartSession: { db, jwt in
                try await database.fetchCartSession(db, from: jwt, logger: database.logger)
                
            }, insertItemsToCart: { db, cart in
                try await database.insertItemsToCart(from: cart, db, logger: database.logger)
            }, connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

