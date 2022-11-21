import PostgresNIO
import Foundation
import UserModel

public struct DatabaseUserClient: Sendable {
    public typealias CreateUser = @Sendable (PostgresConnection, User, String) async throws -> Void
    public typealias FetchLoggedInUserJWT = @Sendable (PostgresConnection, User) async throws -> String
    public typealias SignInUser = @Sendable (PostgresConnection, User) async throws -> String?
    public typealias Connect = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var createUser: CreateUser
    public var fetchLoggedInUserJWT: FetchLoggedInUserJWT
    public var signInUser: SignInUser
    public var connect: Connect
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
    
    public init(
        createUser: @escaping CreateUser,
        fetchLoggedInUserJWT: @escaping FetchLoggedInUserJWT,
        signInUser: @escaping SignInUser,
        connect: @escaping Connect,
        closeDatabaseEventLoop: @escaping CloseDatabaseEventLoop
    ) {
        self.createUser = createUser
        self.fetchLoggedInUserJWT = fetchLoggedInUserJWT
        self.signInUser = signInUser
        self.connect = connect
        self.closeDatabaseEventLoop = closeDatabaseEventLoop
    }
    
}
