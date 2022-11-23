import Vapor
import SiteRouter
import Foundation
import JWT
import UserModel
import DatabaseUserClient
import ComposableArchitecture

public struct UserService: Sendable {
    @Dependency(\.databaseUserClient) var databaseUserClient
    public init() {}
}

public extension UserService {
    func usersHandler(
        route: UserRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case let .create(user):
            let db = try await databaseUserClient.connect()
            
            let jwt = constructJWT(
                secretKey: user.credentials.password,
                header: JWT.Header.init(),
                payload: JWT.Payload(name: user.credentials.email)
            )
            
            try await databaseUserClient.createUser(
                CreateUserRequest(
                    db: db,
                    user: user,
                    jwt: jwt
                )
            )
            
            try await db.close()
            return ResultPayload(forAction: "create", payload: jwt)
            
        case let .login(user):
            let db = try await databaseUserClient.connect()
            let jwt = try await databaseUserClient.signInUser(
                SignInUserRequest(
                    db: db,
                    user: user
                )
            )
            
            try await db.close()
            return ResultPayload(forAction: "login", payload: jwt)
        }
    }
}

extension ResultPayload: Content {}
