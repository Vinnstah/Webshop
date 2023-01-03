import PostgresNIO
import Foundation
import CartModel
import Product

public struct CreateCartSessionRequest: Sendable {
    public let db: PostgresConnection
    public let jwt: Cart.Session.JWT
    public let sessionID: Cart.Session.ID
    
    public init(
        db: PostgresConnection,
        jwt: Cart.Session.JWT,
        sessionID: Cart.Session.ID
    ) {
        self.db = db
        self.jwt = jwt
        self.sessionID = sessionID
    }
}

public struct GetAllItemsInCartRequest: Sendable {
    public let db: PostgresConnection
    public let sessionID: Cart.Session.ID
    
    public init(db: PostgresConnection, sessionID: Cart.Session.ID) {
        self.db = db
        self.sessionID = sessionID
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

public struct RemoveItemFromCartRequest: Sendable {
    public let db: PostgresConnection
    public let id: Cart.Session.ID
    public let product: Product.ID
    
    public init(db: PostgresConnection, id: Cart.Session.ID, product: Product.ID) {
        self.db = db
        self.id = id
        self.product = product
    }
    
}

