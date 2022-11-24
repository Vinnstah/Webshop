import Foundation
import Dependencies

#if DEBUG
import XCTestDynamicOverlay

extension DatabaseUserClient {
    
    static let test = Self(
        createUser: XCTUnimplemented("\(Self.self).createUsercreateUser"),
        fetchLoggedInUserJWT: XCTUnimplemented("\(Self.self).fetchLoggedInUserJWT"),
        signInUser: XCTUnimplemented("\(Self.self).signInUser"),
        connect: XCTUnimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: XCTUnimplemented("\(Self.self).closeDatabaseEventLoop")
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
