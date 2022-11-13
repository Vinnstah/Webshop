import Vapor
import SiteRouter
import Foundation
import DatabaseClient

public extension Server {
    func boardgameHandler(
        route: BoardgameRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case .fetch:
            let db = try await databaseClient.connectToDatabase()
            let boardgames = try await databaseClient.fetchBoardgames(db)
            try await db.close()
            return ResultPayload(forAction: "fetch Boardgames", payload: boardgames)
        }
    }
}
