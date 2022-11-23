import Foundation
import DatabaseBoardgameClient
import ComposableArchitecture
import Database

extension DatabaseBoardgameClient: DependencyKey {
    
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
