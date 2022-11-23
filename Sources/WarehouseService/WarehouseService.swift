import Vapor
import SiteRouter
import Foundation
import Warehouse
import Product
import DatabaseWarehouseClient
import ComposableArchitecture

public struct WarehouseService: Sendable {
    @Dependency(\.databaseWarehouseClient) var databaseWarehouseClient
    public init() {}
}

public extension WarehouseService {
    func warehouseHandler(
        route: WarehouseRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case .fetch:
            let db = try await databaseWarehouseClient.connect()
            let warehouseStatus = try await databaseWarehouseClient.fetchWarehouse(db)
            try await db.close()
            return ResultPayload(forAction: "fetch Warehouse Status", payload: warehouseStatus)
            
        case let .update(product):
            let db = try await databaseWarehouseClient.connect()
            
            let status =
            try await databaseWarehouseClient.updateWarehouse(UpdateWarehouseRequest(db: db, item: product))
            
            try await db.close()
            return ResultPayload(forAction: "update Warehouse Status", payload: status)
            
        case .get(id: let id):
            let db = try await databaseWarehouseClient.connect()
            let warehouseStatus = try await databaseWarehouseClient.fetchWarehouseStatusForProduct(FetchWarehouseStatusForProductRequest(db: db, id: id))
            try await db.close()
            return ResultPayload(forAction: "fetch Warehouse Status For Product", payload: warehouseStatus)
        }
    }
}

extension ResultPayload: Content {}

