
import Foundation
import PostgresNIO
import Logging
import NIOPosix
import SiteRouter
import UserModel
import Vapor
import ProductModel

public let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
public let logger = Logger(label: "postgres-logger")

public func connectDatabase() async throws -> PostgresConnection  {
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

public func insertUser(_ db: PostgresConnection, logger: Logger, user: User) async throws {
    try await db.query("""
                        INSERT INTO users(user_name,password,jwt)
                        VALUES (\(user.email),\(user.password),\(user.jwt));
                        """,
                       logger: logger
    )
}

public func returnUserRowsAsArray(_ rows: PostgresRowSequence) async throws -> [User] {
    var users: [User] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let user = User(
            email: try randomRow["user_name"].decode(String.self, context: .default),
            password: try randomRow["password"].decode(String.self, context: .default),
            jwt: try randomRow["jwt"].decode(String.self, context: .default))
        users.append(user)
    }
    return users
}

public func loginUser(
    _ db: PostgresConnection,
    _ email: String,
    _ password: String
) async throws -> String? {
    let rows = try await db.query(
                    """
                    SELECT * FROM users WHERE user_name=\(email);
                    """,
                    logger: logger
    )
    let user = try await returnUserRowsAsArray(rows).first
    if user == nil {
        return nil
    } else {
        let user = user!
        if user.password == password {
            return user.jwt
        }
        return nil
    }
}

public func returnProductRowsAsArray(_ rows: PostgresRowSequence) async throws -> [Product] {
    var products: [Product] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let product = Product(
            title: try randomRow["title"].decode(String.self, context: .default),
            description: try randomRow["description"].decode(String.self, context: .default),
            imageURL: try randomRow["image_url"].decode(String.self, context: .default),
            price: try randomRow["price"].decode(Int.self, context: .default),
            category: try randomRow["category"].decode(ProductModel.Category.self, context: .default),
            subCategory: try randomRow["sub_category"].decode(String.self, context: .default),
            sku: try randomRow["sku"].decode(String.self, context: .default))
        products.append(product)
       
    }
    return products
}

public func getAllProducts(
    _ db: PostgresConnection
) async throws -> [Product] {
    let rows = try await db.query(
                    """
                    SELECT * FROM products;
                    """,
                    logger: logger
    )
    let products = try await returnProductRowsAsArray(rows)
    return products
}
