import PostgresNIO
import Foundation
import Boardgame
import Dependencies
import Database

public struct DatabaseBoardgameClient: Sendable, DependencyKey {
    public typealias FetchBoardgames = @Sendable (PostgresConnection) async throws -> [Boardgame]
    public typealias Connect = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var fetchBoardgames: FetchBoardgames
    public var connect: Connect
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
    
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(
            fetchBoardgames: {
                try await database.fetchBoardgames($0)
            }, connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
    
}
