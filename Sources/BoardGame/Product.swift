import Foundation
import Tagged

public struct NewProduct: Equatable, Sendable, Identifiable, Codable, Hashable {
    public let boardgame: Boardgame
    public let price: Price
    public let id: ID
    
}

public extension NewProduct {
     typealias ID = Tagged<Self, UUID>
}

public struct Price: Equatable, Sendable, Codable, Hashable {
    public let brutto: Int
    public let currency: Currency
}

public extension Price {
    enum Currency: Equatable, Sendable, Codable, Hashable {
        case sek
        case usd
    }
    
}
