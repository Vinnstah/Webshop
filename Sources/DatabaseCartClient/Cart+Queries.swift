import PostgresNIO
import Foundation
import CartModel
import Product
import Database

public extension Database {
    func createCartSession(
        request: CreateCartSessionRequest
    ) async throws -> Cart.Session {
        try await request.db.query("""
            INSERT INTO cart
            VALUES(\(request.sessionID.rawValue), \(request.jwt.rawValue))
            ON CONFLICT (jwt)
            DO NOTHING;
            """, logger: logger)
        return Cart.Session(id: request.sessionID, jwt: request.jwt)
    }
    
    func fetchCartSession(
        request: FetchCartSessionRequest
    ) async throws -> Cart? {
        let rows = try await request.db.query("""
                        SELECT * FROM cart
                        WHERE jwt=\(request.jwt);
                        """, logger: logger
        )
        guard let session = try await decodeCartSession(from: rows) else {
            return nil
        }
        let cart = Cart(session: session, item: [])
        print(cart)
        return cart
    }
    
    func getAllItemsInCart(
        request: GetAllItemsInCartRequest
    ) async throws -> [Cart.Item ] {
        let itemRows = try await request.db.query("""
                            SELECT product_id, quantity FROM cart_items
                            WHERE cart_id=\(request.sessionID.rawValue);
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

