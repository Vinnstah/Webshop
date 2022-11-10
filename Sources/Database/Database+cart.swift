import PostgresNIO
import Foundation
import CartModel
import Product

public func createCartSession(
    _ db: PostgresConnection,
    from cart: Cart,
    logger: Logger
) async throws -> Cart.Session.ID {
    try await db.query("""
            INSERT INTO cart
            VALUES(\(cart.session.id.rawValue), \(cart.session.jwt.rawValue))
            ON CONFLICT (jwt)
            DO NOTHING;
            """, logger: logger)
    return cart.session.id
}

public func fetchCartSession(
    _ db: PostgresConnection,
    from jwt: String,
    logger: Logger
) async throws -> Cart? {
    let rows = try await db.query("""
                        SELECT * FROM cart
                        WHERE jwt=\(jwt)
                        """, logger: logger
    )
    guard let session = try await decodeCartSession(from: rows) else {
        return nil
    }
    
    var cart = Cart(session: session, item: [])
    let itemRows = try await getAllItemsInCart(from: cart.session, db, logger: logger)

    cart.item = try await decodeItems(from: itemRows)
    
    return cart
}

public func getAllItemsInCart(
    from session: Cart.Session,
    _ db: PostgresConnection,
    logger: Logger
) async throws -> PostgresRowSequence {
    let itemRows = try await db.query("""
                            SELECT * FROM cart_items
                            WHERE cart_id=\(session.id.rawValue))
                            """, logger: logger)
    
    return itemRows
}

public func insertItemsToCart(
    from cart: Cart,
    _ db: PostgresConnection,
    logger: Logger
) async throws -> Cart.Session.ID? {
    for item in cart.item {
        try await db.query("""
            INSERT INTO cart_items
            VALUES(\(cart.session.id.rawValue), \(item.product.rawValue), \(item.quantity.rawValue))
            ON CONFLICT (cart_id, product_id)
            DO
            UPDATE SET quantity=\(item.quantity.rawValue);
            """, logger: logger)
    }
    return cart.session.id
}

public func decodeCartSession(
    from rows: PostgresRowSequence
) async throws -> Cart.Session? {
    
    var sessions: [Cart.Session] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let session = Cart.Session(
            id: Cart.Session.ID(rawValue: try randomRow["cart_id"].decode(UUID.self, context: .default)),
            jwt: Cart.Session.JWT(rawValue: try randomRow["jwt"].decode(String.self, context: .default))
        )
        sessions.append(session)
        
    }
    guard sessions != [] else {
        return nil
    }
    return sessions.first
}

public func decodeItems(
    from rows: PostgresRowSequence
) async throws -> [Cart.Item] {
    
    var items: [Cart.Item] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        
        let item = Cart.Item(
            product: Product.ID(rawValue: try randomRow["product_id"].decode(UUID.self, context: .default)),
            quantity: Cart.Item.Quantity(rawValue: try randomRow["quantity"].decode(Int.self, context: .default))
        )
        
        items.append(item)
    }
    return items
}
