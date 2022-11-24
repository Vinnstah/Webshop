import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay
import Dependencies

#if DEBUG
extension DatabaseBoardgameClient {
    
    public static let test = Self(
        fetchBoardgames: XCTUnimplemented("\(Self.self).fetchBoardgames"),
        connect: XCTUnimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: XCTUnimplemented("\(Self.self).closeDatabaseEventLoop")
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
