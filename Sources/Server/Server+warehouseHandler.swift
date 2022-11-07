import Vapor
import SiteRouter
import Foundation

func warehouseHandler(
    route: WarehouseRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case .fetch:
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    case let .update(product):
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    }
}
