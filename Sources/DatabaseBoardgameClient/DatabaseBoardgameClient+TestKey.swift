import Foundation
import Dependencies

#if DEBUG
import XCTestDynamicOverlay

extension DatabaseBoardgameClient {
    
    public static let test = Self(
        fetchBoardgames: unimplemented("\(Self.self).fetchBoardgames"),
        connect: unimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: unimplemented("\(Self.self).closeDatabaseEventLoop")
    )
}
extension DatabaseBoardgameClient: TestDependencyKey {
    public static let testValue = DatabaseBoardgameClient.test
}
#endif // DEBUG

extension DependencyValues {
    public var databaseBoardgameClient: DatabaseBoardgameClient {
        get { self[DatabaseBoardgameClient.self] }
        set { self[DatabaseBoardgameClient.self] = newValue }
    }
}
