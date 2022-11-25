import Foundation
import Dependencies

#if DEBUG
import XCTestDynamicOverlay

extension DatabaseUserClient {
    
    static let test = Self(
        createUser: unimplemented("\(Self.self).createUsercreateUser"),
        fetchLoggedInUserJWT: unimplemented("\(Self.self).fetchLoggedInUserJWT"),
        signInUser: unimplemented("\(Self.self).signInUser"),
        connect: unimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: unimplemented("\(Self.self).closeDatabaseEventLoop")
    )
}

extension DatabaseUserClient: TestDependencyKey {
    public static let testValue = DatabaseUserClient.test
}
#endif // DEBUG

public extension DependencyValues {
    var databaseUserClient: DatabaseUserClient {
        get { self[DatabaseUserClient.self] }
        set { self[DatabaseUserClient.self] = newValue }
    }
}
