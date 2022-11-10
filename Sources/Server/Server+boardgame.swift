import Vapor
import SiteRouter
import Foundation
import Database

func boardgameHandler(
    route: BoardgameRoute,
    request: Request
) async throws -> any AsyncResponseEncodable {
    
    switch route {
        
    case .fetch:
        let db = try await connectDatabase()
        let boardgames = try await fetchBoardgames(db)
        try await db.close()
        return ResultPayload(forAction: "fetch Boardgames", payload: boardgames)
    }
}
