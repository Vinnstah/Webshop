import Vapor
import SiteRouter
import Foundation
import Warehouse
import Product
import DatabaseClient

public extension Server {
    func warehouseHandler(
        route: WarehouseRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case .fetch:
            let db = try await databaseClient.connectToDatabase()
            let warehouseStatus = try await databaseClient.fetchWarehouse(db)
            try await db.close()
            return ResultPayload(forAction: "fetch Warehouse Status", payload: warehouseStatus)
            
        case let .update(product):
            let db = try await databaseClient.connectToDatabase()
            let status = try await databaseClient.updateWarehouse(db, product)
            try await db.close()
            return ResultPayload(forAction: "update Warehouse Status", payload: status)
            
        case .get(id: let id):
            let db = try await databaseClient.connectToDatabase()
            let warehouseStatus = try await databaseClient.fetchWarehouseStatusForProduct(db, id)
            try await db.close()
            return ResultPayload(forAction: "fetch Warehouse Status For Product", payload: warehouseStatus)
        }
    }
}
