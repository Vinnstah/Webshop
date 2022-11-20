import PostgresNIO
import Foundation
import Boardgame

public struct DatabaseBoardgameClient: Sendable {
    public typealias FetchBoardgames = @Sendable (PostgresConnection) async throws -> [Boardgame]
    
    public var fetchBoardgames: FetchBoardgames
    
    public init(
        fetchBoardgames: @escaping  FetchBoardgames
    ) {
        self.fetchBoardgames = fetchBoardgames
    }
    
}
