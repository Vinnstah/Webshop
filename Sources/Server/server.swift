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
        return constructJWT(secretKey: user.secret, header: JWT.Header.init(), payload: JWT.Payload(name: user.username))
    case let .retrieveSecret(secret):
        guard secret.passcode == "test" else {
            return "INCORRECT"
        }
        return "?E(H+KbeShVmYq3t6w9z$C&F)J@NcQfT"
    }
}
