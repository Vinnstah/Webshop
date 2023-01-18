import Foundation

public struct FavoriteProducts: Equatable, Sendable, Codable {
    
    public var ids: [Product.ID]
    
    public init(ids: [Product.ID] = []) {
        self.ids = ids
    }
}
