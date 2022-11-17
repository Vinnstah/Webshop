
import Foundation
import PostgresNIO
import Logging
import NIOPosix
import Vapor

public struct Database: Sendable {
    public let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)
    public let logger = Logger(label: "postgres-logger")

    public func connect() async throws -> PostgresConnection  {
        let config = PostgresConnection.Configuration(
            connection: .init(
                host: "localhost",
                port: 5432
            ),
            authentication: .init(
                username: Environment.get("WS_USER")!,
                database: Environment.get("WS_DB")!,
                password: Environment.get("WS_PW")!
            ),
            tls: .disable
        )

        let connection = try await PostgresConnection.connect(
            on: eventLoopGroup.next(),
            configuration: config,
            id: 1,
            logger: logger
        )

        return connection
    }

    public func closeDatabaseEventLoop() {
        do {
            try eventLoopGroup.syncShutdownGracefully()
        } catch {
            print("Failed to shutdown DB EventLoopGroup: \(error)")
        }
    }
}
