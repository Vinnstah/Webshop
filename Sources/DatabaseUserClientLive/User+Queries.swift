import Foundation
import UserModel
import PostgresNIO
import Database

public extension Database {
     func createUser(
        in db: PostgresConnection,
        with user: User,
        and jwt: String,
        _ logger: Logger
    ) async throws {
        try await db.query("""
                        INSERT INTO users(user_name,password,jwt)
                        VALUES (\(user.credentials.email),\(user.credentials.hashedPassword),\(jwt));
                        """,
                           logger: logger
        )
    }
    
    func fetchLoggedInUserJWT(
       _ db: PostgresConnection,
       user: User
    ) async throws -> String {
       
       let rows = try await db.query(
                   """
                   SELECT jwt FROM users WHERE user_name=\(user.credentials.email);
                   """,
                   logger: logger
       )
        
        let jwt = try await decodeJWT(from: rows)
       return jwt
       
    }

    func loginUser(
        in db: PostgresConnection,
        with user: User
    ) async throws -> String? {
        let rows = try await db.query(
                    """
                    SELECT user_name, password FROM users WHERE user_name=\(user.credentials.email);
                    """,
                    logger: logger
        )
        guard let databaseUser = try await decodeUsers(from: rows).first else {
            return nil
        }
        
        guard databaseUser.credentials.password == user.credentials.hashedPassword else {
            return nil
        }
        
        let jwt = try await fetchLoggedInUserJWT(db, user: databaseUser)
        return jwt
    }
}
