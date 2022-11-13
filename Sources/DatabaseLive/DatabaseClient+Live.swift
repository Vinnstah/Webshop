import Foundation
import ComposableArchitecture
import Logging
import PostgresNIO
import NIOPosix
import Vapor
import XCTestDynamicOverlay
import DatabaseClient

public extension DatabaseClient {
    
    static let live: Self = {
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

//extension DatabaseClient {
//    public static let unimplemented = Self(
//        fetchBoardgames: { _ in return [] },
//        createCartSession: { _,_  in return .init(rawValue: UUID()) },
//        getAllItemsInCart: { _,_  in return []},
//        fetchCartSession: { _,_  in return nil },
//        insertItemsToCart: { _,_  in return nil },
//        createUser: { _,_,_  in return  },
//        fetchLoggedInUserJWT: { _,_  in return "" },
//        signInUser: { _,_   in return nil },
//        fetchWarehouse: { _ in return [] },
//        fetchWarehouseStatusForProduct: { _,_  in return [] },
//        updateWarehouse: { _,_  in return nil },
//        connectToDatabase: { XCTUnimplementedFailure() as! PostgresConnection },
//        closeDatabaseEventLoop: { return }
//        
//    )
//}
private enum DatabaseClientKey: DependencyKey {
    typealias Value = DatabaseClient
    static let liveValue = DatabaseClient.live
//    static let testValue = DatabaseClient.unimplemented
}
public extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}
