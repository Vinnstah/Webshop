import Foundation
import PostgresNIO
import UserModel

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
