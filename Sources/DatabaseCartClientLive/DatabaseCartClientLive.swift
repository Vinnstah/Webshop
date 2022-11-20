import Foundation
import ComposableArchitecture
import Logging
import PostgresNIO
import NIOPosix
import Vapor
import XCTestDynamicOverlay
import DatabaseCartClient

extension DatabaseCartClient: DependencyKey {
    
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(
           createCartSession: { db, cart in
                try await database.createCartSession(db, from: cart, logger: logger)
                
            }, getAllItemsInCart: { db, session in
                try await database.getAllItemsInCart(from: session, db, logger: logger)
                
            }, fetchCartSession: { db, jwt in
                try await database.fetchCartSession(db, from: jwt, logger: logger)
                
            }, insertItemsToCart: { db, cart in
                try await database.insertItemsToCart(from: cart, db, logger: logger)
        )
    }()
}

