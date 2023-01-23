import CartModel
import Foundation
import PostgresNIO
import Product
import Database

public extension Database {
    func decodeCartSession(
        from rows: PostgresRowSequence
    ) async throws -> Cart.Session? {
        
        var sessions: [Cart.Session] = []
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            let session = try Cart.Session(
                id: Cart.Session.ID(rawValue: randomRow["cart_id"].decode(UUID.self, context: .default)),
                jwt: Cart.Session.JWT(rawValue: randomRow["jwt"].decode(String.self, context: .default))
            )
            sessions.append(session)
            
        }
        guard sessions != [] else {
            return nil
        }
        return sessions.first
    }
    
    func decodeItems(
        from rows: PostgresRowSequence
    ) async throws -> [Cart.Item] {
        
        var items: [Cart.Item] = []
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            let item = try Cart.Item(
                id: Product.ID(rawValue: randomRow["product_id"].decode(UUID.self, context: .default)),
                quantity: Cart.Item.Quantity(rawValue: randomRow["quantity"].decode(Int.self, context: .default))
            )
            items.append(item)
        }
        return items
    }
}
