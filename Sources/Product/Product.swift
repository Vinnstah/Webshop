import Foundation
import Tagged
import Boardgame

public struct Product: Equatable, Sendable, Identifiable, Codable, Hashable {
    public let boardgame: Boardgame
    public let price: Price
    public let id: ID
    
    public init(boardgame: Boardgame, price: Price, id: ID) {
        self.boardgame = boardgame
        self.price = price
        self.id = id
    }
}

public extension Product {
     typealias ID = Tagged<Self, UUID>
}

public extension Product {
     struct Price: Equatable, Sendable, Codable, Hashable {
        public let brutto: Int
        public let currency: Currency
         
         public init(brutto: Int, currency: Currency) {
             self.brutto = brutto
             self.currency = currency
         }
    }
}

public extension Product.Price {
    enum Currency: Equatable, Sendable, Codable, Hashable {
        case sek
    }
}

