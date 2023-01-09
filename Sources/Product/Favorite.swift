import Foundation

public struct FavoriteProducts: Equatable, Sendable, Codable {
    
    public var sku: [Product.ID]
    
    public init(sku: [Product.ID] = []) {
        self.sku = sku
    }
}
