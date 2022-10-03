//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-10-02.
//

import Foundation
import PostgresNIO
import Logging
import NIOPosix
import SiteRouter
import UserModel

public let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
public let logger = Logger(label: "postgres-logger")

public func connectDatabase() async throws -> PostgresConnection  {
    let config = PostgresConnection.Configuration(
        connection: .init(
            host: "localhost",
            port: 5432
        ),
        authentication: .init(
            username: "viktorjansson",
            database: "webshop",
            password: "baloo"
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

public func insertUser(_ db: PostgresConnection, logger: Logger, user: User) async throws {
    try await db.query("""
                        INSERT INTO users(user_name,password,jwt)
                        VALUES (\(user.email),\(user.password),\(user.jwt));
                        """,
                       logger: logger
    )
    
}
