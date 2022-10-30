import Foundation
import UserDefaultsClient
import ProductModel

public struct FavoritesClient: Sendable {
    
    public struct Favourites: Codable {
        var favourites: [Product.SKU]
        
        public init(favourites: [Product.SKU]) {
            self.favourites = favourites
        }
    }
    
    public typealias AddFavorite = @Sendable (Product.SKU) throws -> Product.SKU?
    public typealias RemoveFavorite = @Sendable (Product.SKU) throws -> Product.SKU?
    
    public var addFavorite: AddFavorite
    public var removeFavorite: RemoveFavorite
    
    public init(
        addFavorite: @escaping AddFavorite,
        removeFavorite: @escaping RemoveFavorite
    ) {
        self.addFavorite = addFavorite
        self.removeFavorite = removeFavorite
    }
    
    
    
}


