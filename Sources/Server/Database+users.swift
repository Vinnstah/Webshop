import Foundation
import UserModel
import PostgresNIO

public func insertUser(_ db: PostgresConnection, logger: Logger, user: User) async throws {
    try await db.query("""
                        INSERT INTO users(user_name,password,jwt)
                        VALUES (\(user.credentials.email),\(user.credentials.password),\(user.jwt));
                        """,
                       logger: logger
    )
}

public func fetchUsers(from rows: PostgresRowSequence) async throws -> [User] {
    var users: [User] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let user = User(
            credentials: User.Credentials(
                email: try randomRow["user_name"].decode(String.self, context: .default),
                password: try randomRow["password"].decode(String.self, context: .default)
            ),
            jwt: try randomRow["jwt"].decode(String.self, context: .default)
        )
        users.append(user)
    }
    return users
}


public func loginUser(
    _ db: PostgresConnection,
    _ user: User
) async throws -> String? {
    let rows = try await db.query(
                    """
                    SELECT * FROM users WHERE user_name=\(user.credentials.email);
                    """,
                    logger: logger
    )
    guard let databaseUser = try await fetchUsers(from: rows).first else {
        return nil
    }
    
    guard databaseUser.credentials.hashedPassword == user.credentials.hashedPassword else {
        return nil
    }
    
    return user.jwt
}
