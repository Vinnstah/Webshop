import Foundation
import Tagged
import Boardgame

public struct Product: Equatable, Sendable, Identifiable, Codable, Hashable {
    public let boardgame: Boardgame
    public let price: Price
    public let id: ID
}

public extension Product {
     typealias ID = Tagged<Self, UUID>
}

public extension Product {
     struct Price: Equatable, Sendable, Codable, Hashable {
        public let brutto: Int
        public let currency: Currency
    }
}

public extension Product.Price {
    enum Currency: Equatable, Sendable, Codable, Hashable {
        case sek
    }
}

