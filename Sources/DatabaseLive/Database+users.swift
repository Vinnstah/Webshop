import Foundation
import UserModel
import PostgresNIO

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
    
     func decodeUsers(
        from rows: PostgresRowSequence
    ) async throws -> [User] {
        var users: [User] = []
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            let user = try User(
                credentials: User.Credentials(
                    email: randomRow["user_name"].decode(String.self, context: .default),
                    password: randomRow["password"].decode(String.self, context: .default)
                )
            )
            users.append(user)
        }
        return users
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

    func decodeJWT(from rows: PostgresRowSequence
    ) async throws -> String {
        var jwt: [String] = []
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            let maybeJWT = try randomRow["jwt"].decode(String.self, context: .default)
            jwt.append(maybeJWT)
        }
        return jwt.first ?? "No JWT found"
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
