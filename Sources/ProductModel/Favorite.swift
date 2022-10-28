import Foundation

public struct FavoriteProducts: Equatable, Sendable, Codable {
    
    public var sku: [Product.SKU]
    
    public init(sku: [Product.SKU] = []) {
        self.sku = sku
    }
}
