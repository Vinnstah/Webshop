import Foundation

public struct FavoriteProducts: Equatable {
    
    public let sku: [String]
    
    public init(sku: [String]) {
        self.sku = sku
    }
}
