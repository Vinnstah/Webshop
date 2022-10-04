import Vapor
import VaporRouting
import SiteRouter
import UserModel

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.mount(router, use: siteHandler)
    
}

/// Handles all the actions for each route
func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .create(user):
        let db = try await connectDatabase()
        let jwt = constructJWT(secretKey: user.password, header: JWT.Header.init(), payload: JWT.Payload(name: user.email))
        let updatedUser = User(email: user.email, password: user.password, jwt: jwt, userSettings: user.userSettings)
        
        try await insertUser(db, logger: logger, user: updatedUser)
        try await db.close()
        return updatedUser
        
    case let .login(user):
        let db = try await connectDatabase()
        let dbUser = try await getUser(db, logger: logger, user: user)
        if user.jwt != dbUser.jwt {
            return LoginResponse(status: ["status": "Failed"])
        }
        return LoginResponse(status: ["status": "Success"])
        
    }
}

