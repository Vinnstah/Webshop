import Foundation
import UserModel
import PostgresNIO

public extension Database {
    
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
    
}
