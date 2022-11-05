
import Foundation
import Tagged

public struct NewCart: Equatable, Identifiable, Codable, Sendable, Hashable {
    public let id: ID
    
    public struct Item: Equatable, Codable, Sendable, Hashable  {
        public let product: NewProduct.ID
        public let quantity: Quantity
    }
}

public extension NewCart {
    typealias ID = Tagged<Self, UUID>
}

public extension NewCart {
    struct QuantityTag: Sendable, Codable {}
    typealias Quantity = Tagged<QuantityTag, Int>
}
