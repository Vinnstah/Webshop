import Vapor
import SiteRouter
import Foundation
import DatabaseCartClient
import Dependencies
import CartModel
import Product

public struct CartService: Sendable {
    @Dependency(\.databaseCartClient) var databaseCartClient
    @Dependency(\.uuid) var uuid
    public init() {}
}

public extension CartService {
    func cartHandler(
        route: CartRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case let .create(jwt):
            let db = try await databaseCartClient.connect()
            
            let sessionID = Cart.Session.ID(rawValue: self.uuid.callAsFunction())
            
            let session = try await databaseCartClient.createCartSession(
                CreateCartSessionRequest(
                    db: db,
                    jwt: Cart.Session.JWT(rawValue: jwt),
                    sessionID: Cart.Session.ID(rawValue: sessionID.rawValue)
                )
            )
            
            try await db.close()
            return ResultPayload(forAction: "create Cart", payload: session)
            
        case let .fetch(jwt):
            let db = try await databaseCartClient.connect()
            
            guard let cart = try await databaseCartClient.fetchCartSession(FetchCartSessionRequest(db: db, jwt: jwt)) else {
                try await db.close()
                return ResultPayload(forAction: "fetch Cart Session", payload: jwt)
            }
            
            try await db.close()
            return ResultPayload(forAction: "fetch Cart Session", payload: cart)
            
        case let .fetchAllItems(session: id):
            let db = try await databaseCartClient.connect()
            let item = try await databaseCartClient.getAllItemsInCart(GetAllItemsInCartRequest(db: db, sessionID: Cart.Session.ID(rawValue: id)))
            try await db.close()
            return ResultPayload(forAction: "fetch all items", payload: item)
            
        case let .add(cart):
            print("cart \(cart)")
            let db = try await databaseCartClient.connect()
            print("1")
            let items = try await databaseCartClient.insertItemsToCart(InsertItemsToCartRequest(db: db, cart: cart))
            print(items)
//                try await db.close()
//                print("FALFAFLA")
//                return ResultPayload(forAction: "fetch Cart Session", payload: cart)
//            }
            
//            let items = try await databaseCartClient.getAllItemsInCart(
//                GetAllItemsInCartRequest(
//                    db: db,
//                    sessionID: Cart.Session.ID(rawValue: cart.session.id.rawValue)
//                )
//            )
            try await db.close()
            return ResultPayload(forAction: "Add items to cart", payload: items)
            
        case let .delete(id: id, product: product):
            let db = try await databaseCartClient.connect()
            let payload = try await databaseCartClient.removeItemFromCart(
                RemoveItemFromCartRequest(
                    db: db,
                    id: Cart.Session.ID(rawValue: id),
                    product: Product.ID(rawValue: product)
                )
            )
            try await db.close()
            return ResultPayload(forAction: "remove items to cart", payload: payload)
        }
    }
}

extension ResultPayload: Content {}
