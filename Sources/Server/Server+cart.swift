import Vapor
import SiteRouter
import Foundation
import DatabaseClient

public extension Server {
    func cartHandler(
        route: CartRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case let .create(cart):
            let db = try await databaseClient.connectToDatabase()
            let jwt = try await databaseClient.createCartSession(db, cart)
            try await db.close()
            return ResultPayload(forAction: "create Cart", payload: jwt.rawValue)
            
        case let .fetch(jwt):
            let db = try await databaseClient.connectToDatabase()
            let cart = try await databaseClient.fetchCartSession(db, jwt)
            try await db.close()
            return ResultPayload(forAction: "fetch Cart Session", payload: cart)
            
        case let .add(cart):
            let db = try await databaseClient.connectToDatabase()
            let id = try await databaseClient.insertItemsToCart(db, cart)
            try await db.close()
            return ResultPayload(forAction: "Add items to cart", payload: id)
        }
    }
}

