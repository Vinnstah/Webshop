import PostgresNIO
import Foundation
import Warehouse

public struct DatabaseWarehouseClient: Sendable {
    public typealias FetchWarehouse = @Sendable (PostgresConnection) async throws -> [Warehouse.Item]
    public typealias FetchWarehouseStatusForProduct = @Sendable (PostgresConnection, String) async throws -> [Warehouse.Item]
    public typealias UpdateWarehouse = @Sendable (PostgresConnection, Warehouse.Item) async throws -> String?
    
    public var fetchWarehouse: FetchWarehouse
    public var fetchWarehouseStatusForProduct: FetchWarehouseStatusForProduct
    public var updateWarehouse: UpdateWarehouse
    
    public init(
        fetchWarehouse: @escaping FetchWarehouse,
        fetchWarehouseStatusForProduct: @escaping FetchWarehouseStatusForProduct,
        updateWarehouse: @escaping UpdateWarehouse
    ) {
        self.fetchWarehouse = fetchWarehouse
        self.fetchWarehouseStatusForProduct = fetchWarehouseStatusForProduct
        self.updateWarehouse = updateWarehouse
    }
    
}
