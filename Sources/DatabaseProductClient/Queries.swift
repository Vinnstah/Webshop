import PostgresNIO
import Foundation
import Product
import Database
import Boardgame

public extension Database {
    
    func fetchAllProducts(
        request: GetAllProductsRequest
    ) async throws -> [Product] {
        let rows = try await request.db.query(
                    """
                    SELECT * FROM boardgames
                    INNER JOIN products
                    ON boardgames.boardgame_id = products.boardgame_id;
                    """,
                    logger: logger
        )
        let products = try await decodeProducts(from: rows)
        return products
    }
    
    func decodeProducts(
        from rows: PostgresRowSequence
    ) async throws -> [Product] {
        
        var products: [Product] = []
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            
            let product = try Product(
                boardgame: Boardgame(
                    id: Boardgame.ID(rawValue: randomRow["boardgame_id"].decode(UUID.self, context: .default)),
                    title: randomRow["title"].decode(String.self, context: .default),
                    imageURL: randomRow["image_url"].decode(String.self, context: .default),
                    details: Boardgame.Details(
                        publisher: randomRow["publisher"].decode(String.self, context: .default),
                        releaseOn: randomRow["release_date"].decode(Date.self, context: .default).formatted(.iso8601),
                        playInfo: Boardgame.Details.PlayInfo(
                            duration: randomRow["duration"].decode(Int.self, context: .default),
                            descriptionText: randomRow["description"].decode(String.self, context: .default)),
                        players: Boardgame.Details.PlayersInfo(
                            age: randomRow["age"].decode(Int.self, context: .default),
                            count: Boardgame.Details.PlayersInfo.PlayerCount(
                                min: randomRow["players_min"].decode(Int.self, context: .default),
                                max: randomRow["players_max"].decode(Int.self, context: .default)))),
                    category: Boardgame.Category(rawValue: randomRow["category"].decode(String.self, context: .default)) ?? .classics
                ),
                price: Product.Price(brutto: randomRow["price"].decode(Int.self, context: .default), currency: Product.Price.Currency.sek),
                id: Product.ID(rawValue: randomRow["product_id"].decode(UUID.self, context: .default))
            )
            
            
            products.append(product)
        }
        return products
    }
}
