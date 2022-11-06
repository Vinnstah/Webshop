import Foundation
import Tagged
import ProductModel

public struct Cart: Equatable, Identifiable, Codable, Sendable, Hashable {
    public let id: ID
    
    public struct Item: Equatable, Codable, Sendable, Hashable  {
        public let product: Product.ID
        public let quantity: Quantity
    }
}

public extension Cart {
    typealias ID = Tagged<Self, UUID>
}

public extension Cart {
    struct QuantityTag: Sendable, Codable {}
    typealias Quantity = Tagged<QuantityTag, Int>
}
