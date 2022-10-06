import Vapor
import VaporRouting
import SiteRouter
import UserModel

// configures your application
public func configure(_ app: Application) throws {
    
    app.mount(router, use: siteHandler)
    
}

/// Handles all the actions for each route
func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .create(request):
        let db = try await connectDatabase()
        
        let jwt = constructJWT(
            secretKey: request.password,
            header: JWT.Header.init(),
            payload: JWT.Payload(name: request.email)
        )
        
        let user = User(
            email: request.email,
            password: request.hexedPassword,
            jwt: jwt
        )
        
        try await insertUser(db, logger: logger, user: user)
        try await db.close()
        return ResultPayload(forAction: "create", payload: user.jwt)
        
    case let .login(request):
        let db = try await connectDatabase()
        let jwt = try await loginUser(db, request.email, request.hexedPassword)
        try await db.close()
        return ResultPayload(forAction: "login", payload: jwt)
    }
}


