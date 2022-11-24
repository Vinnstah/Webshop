import PostgresNIO
import Foundation
import CartModel
import Product
import Database
import DatabaseCartClient

public extension Database {
    func createCartSession(
        request: CreateCartSessionRequest
    ) async throws -> Cart.Session.ID {
        try await request.db.query("""
            INSERT INTO cart
            VALUES(\(request.cart.session.id.rawValue), \(request.cart.session.jwt.rawValue))
            ON CONFLICT (jwt)
            DO NOTHING;
            """, logger: logger)
        return request.cart.session.id
    }
    
    func fetchCartSession(
        request: FetchCartSessionRequest
    ) async throws -> Cart? {
        let rows = try await request.db.query("""
                        SELECT * FROM cart
                        WHERE jwt=\(request.jwt)
                        """, logger: logger
        )
        guard let session = try await decodeCartSession(from: rows) else {
            return nil
        }
        
        var cart = Cart(session: session, item: [])
        
        cart.item = try await getAllItemsInCart(request: GetAllItemsInCartRequest(db: request.db, session: cart.session))
        
        return cart
    }
    
    func getAllItemsInCart(
        request: GetAllItemsInCartRequest
    ) async throws -> [Cart.Item] {
        let itemRows = try await request.db.query("""
                            SELECT * FROM cart_items
                            WHERE cart_id=\(request.session.id.rawValue))
                            """, logger: logger)
        
        let items = try await decodeItems(from: itemRows)
        
        return items
    }
    
    func insertItemsToCart(
        request: InsertItemsToCartRequest
    ) async throws -> Cart.Session.ID? {
        for item in request.cart.item {
            try await request.db.query("""
            INSERT INTO cart_items
            VALUES(\(request.cart.session.id.rawValue), \(item.product.rawValue), \(item.quantity.rawValue))
            ON CONFLICT (cart_id, product_id)
            DO
            UPDATE SET quantity=\(item.quantity.rawValue);
            """, logger: logger)
        }
        return request.cart.session.id
    }
}

