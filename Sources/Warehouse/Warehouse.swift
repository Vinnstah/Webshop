import Foundation
import Tagged
import Product

public enum Warehouse {
}

public extension Warehouse {
    struct Item: Sendable, Codable, Hashable, Identifiable {
        public let id: ID
        public let product: Product.ID
        public let quantity: Quantity
        
        public init(id: ID, product: Product.ID, quantity: Quantity) {
            self.id = id
            self.product = product
            self.quantity = quantity
        }
    }
}

public extension Warehouse.Item {
    typealias ID = Tagged<Self, UUID>
}

public extension Warehouse.Item {
    struct QuantityTag: Sendable, Codable {}
    typealias Quantity = Tagged<QuantityTag, Int>
}
