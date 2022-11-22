import Foundation
import Boardgame
import PostgresNIO
import Database

public extension Database {
    func fetchBoardgames(
        _ db: PostgresConnection
    ) async throws -> [Boardgame] {
        let rows = try await db.query(
                    """
                    SELECT * FROM boardgames;
                    """,
                    logger: logger
        )
        let boardgames = try await decodeBoardgames(from: rows)
        return boardgames
    }
    
    func decodeBoardgames(
        from rows: PostgresRowSequence
    ) async throws -> [Boardgame] {
        
        var boardgames: [Boardgame] = []
        
        
        let decoder = JSONDecoder()

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            
            let boardgame = try Boardgame(
                id: Boardgame.ID(rawValue: randomRow["boardgame_id"].decode(UUID.self, context: .default)),
                title: randomRow["title"].decode(String.self, context: .default),
                imageURL: randomRow["image_url"].decode(String.self, context: .default),
                details: Boardgame.Details(
                    publisher: randomRow["publisher"].decode(String.self, context: .default),
                    releaseOn: randomRow["release_date"].decode(Date.self, context: .init(jsonDecoder: decoder)),
                    playInfo: Boardgame.Details.PlayInfo(
                        duration: randomRow["duration"].decode(Int.self, context: .default),
                        descriptionText: randomRow["description"].decode(String.self, context: .default)),
                    players: Boardgame.Details.PlayersInfo(
                        age: randomRow["age"].decode(Int.self, context: .default),
                        count: Boardgame.Details.PlayersInfo.PlayerCount(
                            min: randomRow["players_min"].decode(Int.self, context: .default),
                            max: randomRow["players_max"].decode(Int.self, context: .default)))),
                category: Boardgame.Category(rawValue: randomRow["category"].decode(String.self, context: .default)) ?? .classics
            )
            
            boardgames.append(boardgame)
            
        }
        return boardgames
    }
}