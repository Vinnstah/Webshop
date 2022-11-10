import Vapor
import SiteRouter
import Foundation
import Database

func cartHandler(
    route: CartRoute,
    request: Request
) async throws -> any AsyncResponseEncodable {
    
    switch route {
        
    case let .create(cart):
        let db = try await connectDatabase()
        let jwt = try await createCartSession(db, from: cart, logger: logger)
        try await db.close()
        return ResultPayload(forAction: "create Cart", payload: jwt.rawValue)
        
    case let .fetch(jwt):
        let db = try await connectDatabase()
        let cart = try await fetchCartSession(db, from: jwt, logger: logger)
        try await db.close()
        return ResultPayload(forAction: "fetch Cart Session", payload: cart)
        
    case let .add(cart):
        let db = try await connectDatabase()
        let id = try await insertItemsToCart(from: cart, db, logger: logger)
        try await db.close()
        return ResultPayload(forAction: "Add items to cart", payload: id)
    }
}


