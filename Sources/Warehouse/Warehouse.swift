import Foundation
import Tagged
import Product

public enum Warehouse {
}

public extension Warehouse {
    struct Product: Sendable, Codable, Hashable, Identifiable {
        public let id: ID
        public let product: Product.ID
        public let quantity: Quantity
    }
}

public extension Warehouse {
    typealias ID = Tagged<Self, UUID>
}

public extension Warehouse {
    struct QuantityTag: Sendable, Codable {}
    typealias Quantity = Tagged<QuantityTag, Int>
}
