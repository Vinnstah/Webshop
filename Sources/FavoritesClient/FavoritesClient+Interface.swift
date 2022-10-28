import Foundation
import UserDefaultsClient
import ProductModel

public struct FavoritesClient: Sendable {
    public typealias AddFavorite = @Sendable (Product.SKU) -> Product.SKU?
    
    public var addFavorite: AddFavorite
    
    public init(
        addFavorite: @escaping AddFavorite
    ) {
        self.addFavorite = addFavorite
    }
    
}

private let keyForData: String = "dataKey"

