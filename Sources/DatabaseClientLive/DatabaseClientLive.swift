//import Foundation
//import ComposableArchitecture
//import Logging
//import PostgresNIO
//import NIOPosix
//import Vapor
//import XCTestDynamicOverlay
//import DatabaseClient
//import Database
//
//extension DatabaseClient: DependencyKey {
////    public static let liveValue = DatabaseClient.live
//    
//    public static let liveValue: Self = {
//        let database = Database()
//        let logger = Logger(label: "postgres-logger")
//        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)
//        
//        return Self.init(
//            fetchBoardgames: {
//                try await database.fetchBoardgames($0)
//                
//            }, createCartSession: { db, cart in
//                try await database.createCartSession(db, from: cart, logger: logger)
//                
//            }, getAllItemsInCart: { db, session in
//                try await database.getAllItemsInCart(from: session, db, logger: logger)
//                
//            }, fetchCartSession: { db, jwt in
//                try await database.fetchCartSession(db, from: jwt, logger: logger)
//                
//            }, insertItemsToCart: { db, cart in
//                try await database.insertItemsToCart(from: cart, db, logger: logger)
//                
//            }, createUser: { db, user, jwt in
//                try await database.createUser(in: db, with: user, and: jwt, logger)
//                
//            }, fetchLoggedInUserJWT: { db, user in
//                try await database.fetchLoggedInUserJWT(db, user: user)
//                
//            }, signInUser: { db, user in
//                try await database.loginUser(in: db, with: user)
//                
//            }, fetchWarehouse: { db in
//                try await database.fetchWarehouse(db)
//                
//            }, fetchWarehouseStatusForProduct: { db, id in
//                try await database.fetchWarehouseStatusForProduct(from: id, db)
//                
//            }, updateWarehouse: { db, item in
//                try await database.updateWarehouse(with: item, db)
//                
//            }, connect: {
//                try await database.connect()
//            },
//            closeDatabaseEventLoop: {
//                database.closeDatabaseEventLoop()
//            }
//        )
//    }()
//}
//
