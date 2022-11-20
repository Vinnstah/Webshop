import PostgresNIO
import Foundation
import UserModel

public struct DatabaseUserClient: Sendable {
    public typealias CreateUser = @Sendable (PostgresConnection, User, String) async throws -> Void
    public typealias FetchLoggedInUserJWT = @Sendable (PostgresConnection, User) async throws -> String
    public typealias SignInUser = @Sendable (PostgresConnection, User) async throws -> String?
    
    public var createUser: CreateUser
    public var fetchLoggedInUserJWT: FetchLoggedInUserJWT
    public var signInUser: SignInUser
    
    public init(
        createUser: @escaping CreateUser,
        fetchLoggedInUserJWT: @escaping FetchLoggedInUserJWT,
        signInUser: @escaping SignInUser
    ) {
        self.createUser = createUser
        self.fetchLoggedInUserJWT = fetchLoggedInUserJWT
        self.signInUser = signInUser
    }
    
}
