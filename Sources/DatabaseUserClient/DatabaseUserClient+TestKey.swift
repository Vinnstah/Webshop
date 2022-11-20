import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay
import Dependencies

extension DatabaseUserClient {
    
    static let test = Self(
        createUser: XCTUnimplemented("\(Self.self).createUsercreateUser"),
        fetchLoggedInUserJWT: XCTUnimplemented("\(Self.self).fetchLoggedInUserJWT"),
        signInUser: XCTUnimplemented("\(Self.self).signInUser")
    )
}

extension DatabaseUserClient: TestDependencyKey {
    public static let testValue = DatabaseUserClient.test
}

public extension DependencyValues {
    var databaseUserClient: DatabaseUserClient {
        get { self[DatabaseUserClient.self] }
        set { self[DatabaseUserClient.self] = newValue }
    }
}
