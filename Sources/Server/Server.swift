import Vapor
import VaporRouting
import SiteRouter

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.mount(router, use: siteHandler)
    
}

func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .login(user):
        let db = try await connectDatabase()
        let token = constructJWT(secretKey: user.password, header: JWT.Header.init(), payload: JWT.Payload(name: user.username))
        let userUpdated = UserModel(username: user.username, password: user.password, token: token, secret: user.secret)
        
        _ = try await insertUser(db, logger: logger, user: userUpdated)
        try await db.close()
        return constructJWT(secretKey: user.password, header: JWT.Header.init(), payload: JWT.Payload(name: user.username))
        
    case let .retrieveSecret(secret):
        guard secret.passcode == "test" else {
            return "INCORRECT"
        }
        return ["secret": "?E(H+KbeShVmYq3t6w9z$C&F)J@NcQfT"]
    }
}

