import Foundation
import ComposableArchitecture
import Logging
import PostgresNIO
import NIOPosix
import Vapor
import XCTestDynamicOverlay
import DatabaseUserClient
import Database

extension DatabaseUserClient: DependencyKey {
    
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(
            createUser: {
                try await database.createUser(request: $0)
            },
            fetchLoggedInUserJWT: {
                try await database.fetchLoggedInUserJWT(request: $0)
            },
            signInUser: {
                try await database.loginUser(request: $0)
            },
            connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

