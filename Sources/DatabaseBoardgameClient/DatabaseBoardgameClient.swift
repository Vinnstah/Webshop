import PostgresNIO
import Foundation
import Boardgame

public struct DatabaseBoardgameClient: Sendable {
    public typealias FetchBoardgames = @Sendable (PostgresConnection) async throws -> [Boardgame]
    public typealias Connect = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var fetchBoardgames: FetchBoardgames
    public var connect: Connect
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
    
    public init(
        fetchBoardgames: @escaping  FetchBoardgames,
        connect: @escaping Connect,
        closeDatabaseEventLoop: @escaping CloseDatabaseEventLoop
    ) {
        self.fetchBoardgames = fetchBoardgames
        self.connect = connect
        self.closeDatabaseEventLoop = closeDatabaseEventLoop
    }
    
}
