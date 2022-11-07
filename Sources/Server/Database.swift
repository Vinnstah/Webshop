
import Foundation
import PostgresNIO
import Logging
import NIOPosix
import SiteRouter
import UserModel
import Vapor
import Product
import CartModel

public let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)
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



public func returnCategoryRowsAsArray(_ rows: PostgresRowSequence) async throws -> Set<Product.Category> {
    var categories: Set<Product.Category> = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let category = Category(
            title: try randomRow["category"].decode(String.self, context: .default),
            subCategory: Category.SubCategory(
                title: try randomRow["sub_category"].decode(String.self, context: .default)
            ))
        if categories.contains(where: { $0.title == category.title}) {
        } else {
            categories.insert(category)
        }
    }
    return categories
}

public func returnSubCategoryRowsAsArray(_ rows: PostgresRowSequence) async throws -> Set<Product.Category.SubCategory> {
    var categories: Set<Product.Category.SubCategory> = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let category = Category.SubCategory(
            title: try randomRow["sub_category"].decode(String.self, context: .default)
        )
        if categories.contains(where: { $0.title == category.title}) {
        } else {
            categories.insert(category)
        }
        categories.insert(category)
        
    }
    return categories
}

public func addShoppingCartSession(_ db: PostgresConnection, logger: Logger, cart: Cart) async throws {
    try await db.query("""
                        INSERT INTO shopping_session
                        VALUES(\(cart.id), \(cart.userJWT))
                        ON CONFLICT (jwt)
                        DO NOTHING;
                        """,
                       logger: logger
    )
}

public func getCartSessions(
    _ db: PostgresConnection
) async throws -> [Cart.Session]  {
    let rows = try await db.query(
                                """
                                SELECT * FROM shopping_session;
                                """,
                                logger: logger
    )
    
    let sessions = try await returnCartRowsAsArray(rows)
    return sessions
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


public func addShoppingCartProducts(_ db: PostgresConnection, logger: Logger, cart: Cart) async throws {
    var sessionProdId: String = ""
    for product in cart.products {
        sessionProdId = "\(cart.id)"  + "_" + "\(product.key.id)"
        try await db.query("""
                            INSERT INTO shopping_cart_items
                            VALUES(\(sessionProdId) ,\(cart.id), \(product.key.id), \(product.value), \(product.key.price), \(product.key.sku.rawValue))
                            ON CONFLICT (session_prod_id)
                            DO
                            UPDATE SET quantity = \(product.value)
                            ;
                            """,
                           logger: logger
        )
    }
}

public func getShoppingCartProducts(_ db: PostgresConnection, logger: Logger, sessionID: String) async throws -> Cart {
    
    let rows = try await db.query("""
                                SELECT products.*, shopping_cart_items.session_id, shopping_cart_items.quantity
                                FROM products
                                LEFT JOIN shopping_cart_items
                                ON products.sku = shopping_cart_items.sku
                                WHERE shopping_cart_items.session_id = \(sessionID);
                                """, logger: logger)
    
    let cart = try await returnProductRowsAsCart(rows, id: sessionID)
    
    return cart
}

//TODO: Implement DELETE for products
public func returnProductRowsAsCart(_ rows: PostgresRowSequence, id: String) async throws -> Cart {
    var cart: Cart = .init(id: id, userJWT: "")
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let product = Product(
            id: try randomRow["prod_id"].decode(Int.self, context: .default),
            title: try randomRow["title"].decode(String.self, context: .default),
            description: try randomRow["description"].decode(String.self, context: .default),
            imageURL: try randomRow["image_url"].decode(String.self, context: .default),
            price: try randomRow["price"].decode(Int.self, context: .default),
            category: try randomRow["category"].decode(String.self, context: .default),
            subCategory: try randomRow["sub_category"].decode(String.self, context: .default),
            sku: Product.SKU(rawValue: try randomRow["sku"].decode(String.self, context: .default)),
            quantity: try randomRow["quantity"].decode(Int.self, context: .default))
        
        cart.addItemToCart(product: product, quantity: product.quantity!)
//        cart.addItemToCart(product: product, quantity: try randomRow["quantity"].decode(Int.self, context: .default))
    }
    return cart
}

public func returnProductRowsAsArray(_ rows: PostgresRowSequence) async throws -> [Product] {
    var products: [Product] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let product = Product(
            id: try randomRow["prod_id"].decode(Int.self, context: .default),
            title: try randomRow["title"].decode(String.self, context: .default),
            description: try randomRow["description"].decode(String.self, context: .default),
            imageURL: try randomRow["image_url"].decode(String.self, context: .default),
            price: try randomRow["price"].decode(Int.self, context: .default),
            category: try randomRow["category"].decode(String.self, context: .default),
            subCategory: try randomRow["sub_category"].decode(String.self, context: .default),
            sku: Product.SKU(rawValue: try randomRow["sku"].decode(String.self, context: .default)),
            quantity: nil)
        products.append(product)

    }
    return products
}

public func returnCartRowsAsArray(_ rows: PostgresRowSequence) async throws -> [Cart.Session] {
    var sessions: [Cart.Session] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let session = Cart.Session(
            id: try randomRow["session_id"].decode(String.self, context: .default),
            jwt: try randomRow["jwt"].decode(String.self, context: .default),
            dbID: try randomRow["db_id"].decode(Int.self, context: .default)
        )
        sessions.append(session)
    }
    return sessions
}


public func getAllCategories(
    _ db: PostgresConnection
) async throws -> Set<Product.Category> {
    let rows = try await db.query(
                    """
                    SELECT category,sub_category FROM products;
                    """,
                    logger: logger
    )
    let categories = try await returnCategoryRowsAsArray(rows)
    return categories
}

public func getAllSubCategories(
    _ db: PostgresConnection
) async throws -> Set<Product.Category.SubCategory> {
    let rows = try await db.query(
                    """
                    SELECT sub_category FROM products;
                    """,
                    logger: logger
    )
    let categories = try await returnSubCategoryRowsAsArray(rows)
    return categories
}
