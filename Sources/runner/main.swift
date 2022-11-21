import Server
import Vapor
import Database
import ComposableArchitecture


let server = Server()
var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
let database = Database()
defer {
    app.shutdown()
    database.closeDatabaseEventLoop()
}
try server.configure(app)
try app.run()
