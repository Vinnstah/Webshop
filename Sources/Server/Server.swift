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

func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .login(user):
        let db = try await connectDatabase()
        let jwt = constructJWT(secretKey: user.password, header: JWT.Header.init(), payload: JWT.Payload(name: user.email))
        let updatedUser = User(email: user.email, password: user.password, jwt: jwt, userSettings: user.userSettings)
        
        try await insertUser(db, logger: logger, user: updatedUser)
        try await db.close()
//        return CreateUserResponse(email: user.email, jwt: jwt, status: "Ok")
        return updatedUser
//        return constructJWT(secretKey: user.password, header: JWT.Header.init(), payload: JWT.Payload(name: user.email))
        
    case let .retrieveSecret(secret):
        guard secret.passcode == "test" else {
            return "INCORRECT"
        }
        return ["secret": "?E(H+KbeShVmYq3t6w9z$C&F)J@NcQfT"]
    }
}

