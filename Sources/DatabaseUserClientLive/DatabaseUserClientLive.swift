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
            createUser: { db, user, jwt in
                try await database.createUser(in: db, with: user, and: jwt, database.logger)
                
            }, fetchLoggedInUserJWT: { db, user in
                try await database.fetchLoggedInUserJWT(db, user: user)
                
            }, signInUser: { db, user in
                try await database.loginUser(in: db, with: user)
            }, connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}

