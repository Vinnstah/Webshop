import PostgresNIO
import Foundation
import CartModel
import Product

public extension Database {
    func createCartSession(
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
    
    func fetchCartSession(
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
//        let itemRows = try await getAllItemsInCart(from: cart.session, db, logger: logger)
        
        cart.item = try await getAllItemsInCart(from: cart.session, db, logger: logger)
        
        return cart
    }
    
    func getAllItemsInCart(
        from session: Cart.Session,
        _ db: PostgresConnection,
        logger: Logger
    ) async throws -> [Cart.Item] {
        let itemRows = try await db.query("""
                            SELECT * FROM cart_items
                            WHERE cart_id=\(session.id.rawValue))
                            """, logger: logger)
        
        let items = try await decodeItems(from: itemRows)
        
        return items
    }
    
    func insertItemsToCart(
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
}

