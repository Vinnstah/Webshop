import Vapor
import SiteRouter
import Foundation
import JWT
import UserModel
import Database

func usersHandler(
    route: UserRoute,
    request: Request
) async throws -> any AsyncResponseEncodable {
    
    switch route {
        
    case let .create(user):
        let db = try await connectDatabase()
        
        let jwt = constructJWT(
            secretKey: user.credentials.password,
            header: JWT.Header.init(),
            payload: JWT.Payload(name: user.credentials.email)
        )
        
        try await createUser(in: db,  with: user, and: jwt, logger)
        try await db.close()
        return ResultPayload(forAction: "create", payload: jwt)
        
    case let .login(user):
        let db = try await connectDatabase()
        let jwt = try await loginUser(in: db, with: user)
        try await db.close()
        return ResultPayload(forAction: "login", payload: jwt)
    }
}
