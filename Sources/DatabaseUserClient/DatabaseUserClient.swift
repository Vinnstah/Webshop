import PostgresNIO
import Foundation
import UserModel
import Dependencies
import Database

public struct DatabaseUserClient: Sendable, DependencyKey {
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
    
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(
            createUser: {
                try await database.createUser(request: $0)
            },
            fetchLoggedInUserJWT: {
                try await database.fetchLoggedInUserJWT(request: $0)
            },
            signInUser: {
                try await database.loginUser(request: $0)
            },
            connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

