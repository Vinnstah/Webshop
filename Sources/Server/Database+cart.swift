import PostgresNIO
import Foundation
import CartModel
import Product

public func createCartSession(
    _ db: PostgresConnection,
    from cart: Cart,
    with jwt: String,
    logger: Logger
) async throws -> Cart.ID? {
    var allProductsInCart: [UUID] = []
    for item in cart.item {
        allProductsInCart.append(item.product.rawValue)
    }
    
    var quantityOfAllProductsInCart: [Int] = []
    for item in cart.item {
        quantityOfAllProductsInCart.append(item.quantity.rawValue)
    }
    
    try await db.query("""
            INSERT INTO cart
            VALUES(\(cart.id.rawValue), ARRAY[\(allProductsInCart)], ARRAY[\(quantityOfAllProductsInCart), \(jwt))
            ON CONFLICT (jwt)
            DO NOTHING;
            """, logger: logger)
    
    return cart.id
}

public func fetchCartSession(
    _ db: PostgresConnection,
    from id: Cart.ID,
    logger: Logger
) async throws -> Cart? {
    let rows = try await db.query("""
                        SELECT * FROM cart
                        WHERE cart_id=\(id.rawValue)
                        """, logger: logger)
    let cart = try await decodeCartSession(from: rows)
    return cart
    
}

public func decodeCartSession(from rows: PostgresRowSequence) async throws -> Cart {
    var cart: Cart? = nil
    var item: [Cart.Item] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        item.append(Cart.Item(
            product: Product.ID(rawValue: try randomRow["product_id"].decode(UUID.self, context: .default)),
            quantity: Cart.Quantity(rawValue: try randomRow["quantity"].decode(Int.self, context: .default))
        ))
        cart = Cart(
            id: Cart.ID(rawValue: try randomRow["cart_id"].decode(UUID.self, context: .default)),
            item: [Cart.Item(
                product: Product.ID(rawValue: try randomRow["product_id"].decode(UUID.self, context: .default)),
                quantity: Cart.Quantity(rawValue: try randomRow["quantity"].decode(Int.self, context: .default)))
            ]
        )
    }
    return cart!
}
    


//                       CREATE TABLE cart ( db_id SERIAL , cart_id uuid PRIMARY KEY, product_id_quantity text[][], jwt VARCHAR );
//    db.query("""
//INSERT INTO cart
//VALUES(\(cart.id.rawValue), ARRAY[[\(allProductsInCart)], [\(quantityOfAllProductsInCart)]], \(jwt)
//""", logger: logger)
//    try await db.query("""
//                        INSERT INTO shopping_session
//                        VALUES(\(cart.id.rawValue), \(cart.item))
//                        ON CONFLICT (jwt)
//                        DO NOTHING;
//                        """,
//                       logger: logger
//                       )
//
//    return cart.id


//
//case let .items(route):
//    return try await itemsHandler(route: route)
//case let .create(cart):
//    return ResultPayload(forAction: "placeholder", payload: "placerholder")
//case .fetch(id: let id):
//    return ResultPayload(forAction: "placeholder", payload: "placerholder")
//}
//}
//
//func itemsHandler(
//route: ItemRoute
//) async throws -> any AsyncResponseEncodable {
//switch route {
//case .fetch:
//    return ResultPayload(forAction: "placeholder", payload: "placerholder")
//case let .add(item):
//    return ResultPayload(forAction: "placeholder", payload: "placerholder")
//}
//}
