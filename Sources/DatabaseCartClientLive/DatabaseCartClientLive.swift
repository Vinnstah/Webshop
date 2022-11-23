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
           createCartSession: {
               try await database.createCartSession(request: $0)
                
            }, getAllItemsInCart: {
                try await database.getAllItemsInCart(request: $0)
                
            }, fetchCartSession: {
                try await database.fetchCartSession(request: $0)
                
            }, insertItemsToCart: {
                try await database.insertItemsToCart(request: $0)
            }, connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

