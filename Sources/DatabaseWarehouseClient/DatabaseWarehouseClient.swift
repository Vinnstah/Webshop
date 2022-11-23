import PostgresNIO
import Foundation
import Warehouse

public struct DatabaseWarehouseClient: Sendable {
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
    
    public init(
        fetchWarehouse: @escaping FetchWarehouse,
        fetchWarehouseStatusForProduct: @escaping FetchWarehouseStatusForProduct,
        updateWarehouse: @escaping UpdateWarehouse,
        connect: @escaping Connect,
        closeDatabaseEventLoop: @escaping CloseDatabaseEventLoop
    ) {
        self.fetchWarehouse = fetchWarehouse
        self.fetchWarehouseStatusForProduct = fetchWarehouseStatusForProduct
        self.updateWarehouse = updateWarehouse
        self.connect = connect
        self.closeDatabaseEventLoop = closeDatabaseEventLoop
    }
}

public struct FetchWarehouseStatusForProductRequest: Sendable {
    public let db: PostgresConnection
    public let id: String
    
    public init(db: PostgresConnection, id: String) {
        self.db = db
        self.id = id
    }
}

public struct UpdateWarehouseRequest: Sendable {
    public let db: PostgresConnection
    public let item: Warehouse.Item
    
    public init(db: PostgresConnection, item: Warehouse.Item) {
        self.db = db
        self.item = item
    }
}

