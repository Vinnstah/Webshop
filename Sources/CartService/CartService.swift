import Vapor
import SiteRouter
import Foundation
import DatabaseCartClient
import ComposableArchitecture

public struct CartService: Sendable {
    @Dependency(\.databaseCartClient) var databaseCartClient
    public init() {}
}

public extension CartService {
    func cartHandler(
        route: CartRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case let .create(cart):
            let db = try await databaseCartClient.connect()
            let jwt = try await databaseCartClient.createCartSession(CreateCartSessionRequest(db: db, cart: cart))
            try await db.close()
            return ResultPayload(forAction: "create Cart", payload: jwt.rawValue)
            
        case let .fetch(jwt):
            let db = try await databaseCartClient.connect()
            let cart = try await databaseCartClient.fetchCartSession(FetchCartSessionRequest(db: db, jwt: jwt))
            try await db.close()
            return ResultPayload(forAction: "fetch Cart Session", payload: cart)
            
        case let .add(cart):
            let db = try await databaseCartClient.connect()
            let id = try await databaseCartClient.insertItemsToCart(InsertItemsToCartRequest(db: db, cart: cart))
            try await db.close()
            return ResultPayload(forAction: "Add items to cart", payload: id)
        }
    }
}

extension ResultPayload: Content {}
