import Foundation
import UserModel
import PostgresNIO
import Database
import DatabaseUserClient

public extension Database {
     func createUser(
        request: CreateUserRequest
    ) async throws {
        try await request.db.query("""
                        INSERT INTO users(user_name,password,jwt)
                        VALUES (\(request.user.credentials.email),\(request.user.credentials.hashedPassword),\(request.jwt));
                        """,
                                   logger: logger
        )
    }
    
    func fetchLoggedInUserJWT(
        request: FetchLoggedInUserJWTRequest
    ) async throws -> String {
       
        let rows = try await request.db.query(
                   """
                   SELECT jwt FROM users WHERE user_name=\(request.user.credentials.email);
                   """,
                   logger: logger
       )
        
        let jwt = try await decodeJWT(from: rows)
       return jwt
       
    }

    func loginUser(
        request: SignInUserRequest
    ) async throws -> String? {
        let rows = try await request.db.query(
                    """
                    SELECT user_name, password FROM users WHERE user_name=\(request.user.credentials.email);
                    """,
                    logger: logger
        )
        guard let databaseUser = try await decodeUsers(from: rows).first else {
            return nil
        }
        
        guard databaseUser.credentials.password == request.user.credentials.hashedPassword else {
            return nil
        }
        
        let jwt = try await fetchLoggedInUserJWT(request: .init(db: request.db, user: request.user))
        return jwt
    }
}
