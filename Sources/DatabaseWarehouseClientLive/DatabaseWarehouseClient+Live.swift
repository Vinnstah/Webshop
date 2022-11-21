import Foundation
import ComposableArchitecture
import Logging
import PostgresNIO
import NIOPosix
import Vapor
import XCTestDynamicOverlay
import DatabaseWarehouseClient
import Database

extension DatabaseWarehouseClient: DependencyKey {
    
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(fetchWarehouse: { db in
                try await database.fetchWarehouse(db)
                
            }, fetchWarehouseStatusForProduct: { db, id in
                try await database.fetchWarehouseStatusForProduct(from: id, db)
                
            }, updateWarehouse: { db, item in
                try await database.updateWarehouse(with: item, db)
            }, connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

