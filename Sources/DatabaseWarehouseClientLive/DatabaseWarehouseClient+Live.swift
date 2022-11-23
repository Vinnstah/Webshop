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
        
        return Self.init(
            fetchWarehouse: {
                try await database.fetchWarehouse($0)
            },
            
            fetchWarehouseStatusForProduct: {
                try await database.fetchWarehouseStatusForProduct(request: $0)
            },
            
            updateWarehouse: {
                try await database.updateWarehouse(request: $0)
            },
            
            connect: {
                try await database.connect()
            },
            
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

