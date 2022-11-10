import Server
import Vapor
import Database

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer {
    app.shutdown()
    closeDatabaseEventLoop()
}
try configure(app)
try app.run()
