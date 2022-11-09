import Vapor
import SiteRouter
import Foundation
import Warehouse
import Product

func warehouseHandler(
    route: WarehouseRoute,
    request: Request
) async throws -> any AsyncResponseEncodable {
    switch route {
    case .fetch:
        let db = try await connectDatabase()
        let warehouseStatus = try await fetchWarehouse(db)
        try await db.close()
        return ResultPayload(forAction: "fetchWarehouseStatus", payload: warehouseStatus)
        
    case let .update(product):
        let db = try await connectDatabase()
        let status = try await updateWarehouse(with: product, db)
        try await db.close()
        return ResultPayload(forAction: "updateWarehouseStatus", payload: status)
        
    case .get(id: let id):
        let db = try await connectDatabase()
        let warehouseStatus = try await fetchWarehouseStatusForProduct(from: id, db)
        try await db.close()
        return ResultPayload(forAction: "fetchWarehouseStatusForProduct", payload: warehouseStatus)
    }
}
