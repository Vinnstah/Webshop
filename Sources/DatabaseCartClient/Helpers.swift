import PostgresNIO
import Foundation
import CartModel

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
