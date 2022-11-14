import Foundation
import ComposableArchitecture
import Logging
import PostgresNIO
import NIOPosix
import Vapor
import XCTestDynamicOverlay
import DatabaseClient

extension DatabaseClient: DependencyKey {
    public static let liveValue = DatabaseClient.live
    
    public static let live: Self = {
        let database = Database()
        let logger = Logger(label: "postgres-logger")
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)
        
        return Self.init(
            fetchBoardgames: { db in
                let boardgames = try await database.fetchBoardgames(db)
                
                return boardgames
            }, createCartSession: { db, cart in
                let sessionID = try await database.createCartSession(db, from: cart, logger: logger)
                
                return sessionID
            }, getAllItemsInCart: { db, session in
                let items = try await database.getAllItemsInCart(from: session, db, logger: logger)
                return items
            }, fetchCartSession: { db, jwt in
                let session = try await database.fetchCartSession(db, from: jwt, logger: logger)
                
                return session
            }, insertItemsToCart: { db, cart in
                let id = try await database.insertItemsToCart(from: cart, db, logger: logger)
                
                return id
            }, createUser: { db, user, jwt in
                try await database.createUser(in: db, with: user, and: jwt, logger)
                
            }, fetchLoggedInUserJWT: { db, user in
                let jwt = try await database.fetchLoggedInUserJWT(db, user: user)
                
                return jwt
            }, signInUser: { db, user in
                let jwt = try await database.loginUser(in: db, with: user)
                
                return jwt
            }, fetchWarehouse: { db in
                let warehouse = try await database.fetchWarehouse(db)
                
                return warehouse
            }, fetchWarehouseStatusForProduct: { db, id in
                let warehouseStatus = try await database.fetchWarehouseStatusForProduct(from: id, db)
                
                return warehouseStatus
            }, updateWarehouse: { db, item in
                let id = try await database.updateWarehouse(with: item, db)
                
                return id
            }, connectToDatabase: {
                try await database.connectDatabase()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

