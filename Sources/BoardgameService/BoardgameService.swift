import Vapor
import SiteRouter
import Foundation
import DatabaseBoardgameClient
import Dependencies

public struct BoardgameService: Sendable {
    @Dependency(\.databaseBoardgameClient) var databaseBoardgameClient
    public init() {}
}

public extension BoardgameService {
    func boardgameHandler(
        route: BoardgameRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case .fetch:
            let db = try await self.databaseBoardgameClient.connect()
            let boardgames = try await self.databaseBoardgameClient.fetchBoardgames(db)
            try await db.close()
            return ResultPayload(forAction: "fetch Boardgames", payload: boardgames)
        }
    }
}

extension ResultPayload: Content {}
