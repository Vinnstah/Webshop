import PostgresNIO
import Foundation
import UserModel

public struct DatabaseUserClient: Sendable {
    public typealias CreateUser = @Sendable (CreateUserRequest) async throws -> Void
    public typealias FetchLoggedInUserJWT = @Sendable (FetchLoggedInUserJWTRequest) async throws -> String
    public typealias SignInUser = @Sendable (SignInUserRequest) async throws -> String?
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

public struct CreateUserRequest: Sendable {
    public let db: PostgresConnection
    public let user: User
    public let jwt: String
    
    public init(db: PostgresConnection, user: User, jwt: String) {
        self.db = db
        self.user = user
        self.jwt = jwt
    }
}

public struct FetchLoggedInUserJWTRequest: Sendable {
    public let db: PostgresConnection
    public let user: User
    
    public init(db: PostgresConnection, user: User) {
        self.db = db
        self.user = user
    }
}

public struct SignInUserRequest: Sendable {
    public let db: PostgresConnection
    public let user: User
    
    public init(db: PostgresConnection, user: User) {
        self.db = db
        self.user = user
    }
}
