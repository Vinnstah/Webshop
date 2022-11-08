import Foundation
import Tagged
import Product
import PostgresNIO

public struct Cart: Equatable, Identifiable, Codable, Sendable, Hashable {
    public let id: ID
    public let item: [Item]
    
    public init(id: ID, item: [Item]) {
        self.id = id
        self.item = item
    }
    
    public struct Item: Equatable, Codable, Sendable, Hashable  {
        
        public let product: Product.ID
        public let quantity: Quantity
        
        public init(product: Product.ID, quantity: Quantity) {
            self.product = product
            self.quantity = quantity
        }
    }
}

public extension Cart {
    typealias ID = Tagged<Self, UUID>
}

public extension Cart {
    struct QuantityTag: Sendable, Codable {}
    typealias Quantity = Tagged<QuantityTag, Int>
}
