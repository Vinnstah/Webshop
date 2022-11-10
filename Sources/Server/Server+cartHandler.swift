import Vapor
import SiteRouter
import Foundation

func cartHandler(
    route: CartRoute,
    request: Request
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .create(cart):
        let db = try await connectDatabase()
        let jwt = try await createCartSession(db, from: cart, logger: logger)
        try await db.close()
        return ResultPayload(forAction: "placeholder", payload: jwt.rawValue)
        
    case .fetch(id: let id):
        let db = try await connectDatabase()
        let cart = try await fetchCartSession(db, from: id, logger: logger)
        try await db.close()
        return ResultPayload(forAction: "placeholder", payload: cart)
        
    case .add(item: let item):
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    case .fetchItems:
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    }
}


