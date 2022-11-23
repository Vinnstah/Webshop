import PostgresNIO
import Foundation
import CartModel

public struct DatabaseCartClient: Sendable {
    public typealias CreateCartSession = @Sendable (CreateCartSessionRequest) async throws -> Cart.Session.ID
    public typealias GetAllItemsInCart = @Sendable (GetAllItemsInCartRequest) async throws -> [Cart.Item]
    public typealias FetchCartSession = @Sendable (FetchCartSessionRequest) async throws -> Cart?
    public typealias InsertItemsToCart = @Sendable (InsertItemsToCartRequest) async throws -> Cart.Session.ID?
    public typealias Connect = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var createCartSession: CreateCartSession
    public var getAllItemsInCart: GetAllItemsInCart
    public var fetchCartSession: FetchCartSession
    public var insertItemsToCart: InsertItemsToCart
    public var connect: Connect
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
    
    public init(
        createCartSession: @escaping CreateCartSession,
        getAllItemsInCart: @escaping GetAllItemsInCart,
        fetchCartSession: @escaping FetchCartSession,
        insertItemsToCart: @escaping InsertItemsToCart,
        connect: @escaping Connect,
        closeDatabaseEventLoop: @escaping CloseDatabaseEventLoop
    ) {
        self.createCartSession = createCartSession
        self.getAllItemsInCart = getAllItemsInCart
        self.fetchCartSession = fetchCartSession
        self.insertItemsToCart = insertItemsToCart
        self.connect = connect
        self.closeDatabaseEventLoop = closeDatabaseEventLoop
    }
}

public struct CreateCartSessionRequest: Sendable {
    public let db: PostgresConnection
    public let cart: Cart
    
    public init(db: PostgresConnection, cart: Cart) {
        self.db = db
        self.cart = cart
    }
}

public struct GetAllItemsInCartRequest: Sendable {
    public let db: PostgresConnection
    public let session: Cart.Session
    
    public init(db: PostgresConnection, session: Cart.Session) {
        self.db = db
        self.session = session
    }
}

public struct FetchCartSessionRequest: Sendable {
    public let db: PostgresConnection
    public let jwt: String
    
    public init(db: PostgresConnection, jwt: String) {
        self.db = db
        self.jwt = jwt
    }
}

public struct InsertItemsToCartRequest: Sendable {
    public let db: PostgresConnection
    public let cart: Cart
    
    public init(db: PostgresConnection, cart: Cart) {
        self.db = db
        self.cart = cart
    }
}
