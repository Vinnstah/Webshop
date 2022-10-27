import Foundation

public struct FavoriteProducts: Equatable, Sendable {
    
    public var sku: [String?]
    
    public init(sku: [String?] = [nil]) {
        self.sku = sku
    }
    
    public mutating func addFavoriteProducts(products: [String]) {
        self.sku = products
    }
}
