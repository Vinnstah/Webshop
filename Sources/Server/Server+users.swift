import Vapor
import SiteRouter
import Foundation
import JWT
import UserModel
import DatabaseClient

public extension Server {
    func usersHandler(
        route: UserRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case let .create(user):
            let db = try await databaseClient.connectToDatabase()
            
            let jwt = constructJWT(
                secretKey: user.credentials.password,
                header: JWT.Header.init(),
                payload: JWT.Payload(name: user.credentials.email)
            )
            
            try await databaseClient.createUser(db, user, jwt)
            try await db.close()
            return ResultPayload(forAction: "create", payload: jwt)
            
        case let .login(user):
            let db = try await databaseClient.connectToDatabase()
            let jwt = try await databaseClient.signInUser(db, user)
            try await db.close()
            return ResultPayload(forAction: "login", payload: jwt)
        }
    }
}
