import Foundation
import Boardgame
import PostgresNIO

public func fetchBoardgames(
    _ db: PostgresConnection
) async throws -> [Boardgame] {
    let rows = try await db.query(
                    """
                    SELECT * FROM boardgames;
                    """,
                    logger: logger
    )
    let boardgames = try await fetchBoardgames(from: rows)
    return boardgames
}

public func fetchBoardgames(from rows: PostgresRowSequence) async throws -> [Boardgame] {
    var boardgames: [Boardgame] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let boardgame = Boardgame(
            id: Boardgame.ID(rawValue: try randomRow["boardgame_id"].decode(UUID.self, context: .default)),
            title: try randomRow["title"].decode(String.self, context: .default),
            imageURL: try randomRow["image_url"].decode(String.self, context: .default),
            details: .init(
                publisher: try randomRow["publisher"].decode(String.self, context: .default),
                releaseOn: try randomRow["release_date"].decode(Date.self, context: .default),
                playInfo: .init(
                    duration: try randomRow["duration"].decode(Int.self, context: .default),
                    descriptionText: try randomRow["description"].decode(String.self, context: .default)),
                players: .init(
                    age: try randomRow["age"].decode(Int.self, context: .default),
                    count: .init(
                        min: try randomRow["players_min"].decode(Int.self, context: .default),
                        max: try randomRow["players_max"].decode(Int.self, context: .default))
                )
            ),
            category: .init(rawValue: try randomRow["category"].decode(String.self, context: .default))!
        )
        
        boardgames.append(boardgame)

    }
    return boardgames
}
