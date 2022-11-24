import PostgresNIO
import Foundation
import Warehouse
import Database
import Dependencies

public struct DatabaseWarehouseClient: Sendable, DependencyKey {
    public typealias FetchWarehouse = @Sendable (PostgresConnection) async throws -> [Warehouse.Item]
    public typealias FetchWarehouseStatusForProduct = @Sendable (FetchWarehouseStatusForProductRequest) async throws -> [Warehouse.Item]
    public typealias UpdateWarehouse = @Sendable (UpdateWarehouseRequest) async throws -> String?
    public typealias Connect = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var fetchWarehouse: FetchWarehouse
    public var fetchWarehouseStatusForProduct: FetchWarehouseStatusForProduct
    public var updateWarehouse: UpdateWarehouse
    public var connect: Connect
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
    
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
