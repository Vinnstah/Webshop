import Server
import Vapor
import DatabaseClient
import ComposableArchitecture

let server = Server()
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer {
    app.shutdown()
    DatabaseClient.live.closeDatabaseEventLoop()
}
try server.configure(app)
try app.run()
