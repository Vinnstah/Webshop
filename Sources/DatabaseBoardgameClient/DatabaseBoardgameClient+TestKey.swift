import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay
import Dependencies

extension DatabaseBoardgameClient {
    
    static let test = Self(
        fetchBoardgames: XCTUnimplemented("\(Self.self).fetchBoardgames"),
        connect: XCTUnimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: XCTUnimplemented("\(Self.self).closeDatabaseEventLoop")
    )
}
extension DatabaseBoardgameClient: TestDependencyKey {
    public static let testValue = DatabaseBoardgameClient.test
}

public extension DependencyValues {
    var databaseBoardgameClient: DatabaseBoardgameClient {
        get { self[DatabaseBoardgameClient.self] }
        set { self[DatabaseBoardgameClient.self] = newValue }
    }
}
