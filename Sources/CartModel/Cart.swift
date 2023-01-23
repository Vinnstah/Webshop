import Foundation
import Tagged
import Product

public struct Cart: Equatable, Codable, Sendable, Hashable {
    public var session: Session
    public var item: [Item]
    
    public init(session: Session, item: [Item]) {
        self.session = session
        self.item = item
    }
}

public extension Cart {
    struct Session: Identifiable, Equatable, Codable, Sendable, Hashable {
        
        public var id: ID
        public var jwt: JWT
        
        public init(id: ID, jwt: JWT) {
            self.id = id
            self.jwt = jwt
        }
    }
}

public extension Cart {
    struct Item: Equatable, Codable, Sendable, Hashable, Identifiable  {
        
        public var id: Product.ID
        public var quantity: Quantity
//        public var id:  {
//            self.product
//        }
        
        public init(id: Product.ID, quantity: Quantity) {
            self.id = id
            self.quantity = quantity
        }
        
        
    }
}

public extension Cart.Session {
    typealias ID = Tagged<Self, UUID>
}

public extension Cart.Session {
    struct JWTTag: Sendable, Codable {}
    typealias JWT = Tagged<JWTTag, String>
}

public extension Cart.Item {
    struct QuantityTag: Sendable, Codable {}
    typealias Quantity = Tagged<QuantityTag, Int>
}
