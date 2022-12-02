import Foundation
import Dependencies

#if DEBUG
import XCTestDynamicOverlay

extension DatabaseProductClient {
    
    static let test = Self(
        getAllProducts: unimplemented("\(Self.self).getAllProducts"),
        connect: unimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: unimplemented("\(Self.self).closeDatabaseEventLoop")
    )
}
extension DatabaseProductClient: TestDependencyKey {
    public static let testValue = DatabaseProductClient.test
}
#endif // DEBUG

public extension DependencyValues {
    var databaseProductClient: DatabaseProductClient {
        get { self[DatabaseProductClient.self] }
        set { self[DatabaseProductClient.self] = newValue }
    }
}
