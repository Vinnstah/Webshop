import Foundation
import UserDefaultsClient
import Product

public struct FavoritesClient: Sendable {
    
    public struct Favourites: Codable {
        var favourites: [Product.ID]
        
        public init(favourites: [Product.ID]) {
            self.favourites = favourites
        }
    }
    
    public typealias AddFavorite = @Sendable (Product.ID) throws -> Product.ID?
    public typealias RemoveFavorite = @Sendable (Product.ID) throws -> Product.ID?
    public typealias GetFavourites = @Sendable () throws -> [Product.ID]?
    
    public var addFavorite: AddFavorite
    public var removeFavorite: RemoveFavorite
    public var getFavourites: GetFavourites
    
    public init(
        addFavorite: @escaping AddFavorite,
        removeFavorite: @escaping RemoveFavorite,
        getFavourites: @escaping GetFavourites
    ) {
        self.addFavorite = addFavorite
        self.removeFavorite = removeFavorite
        self.getFavourites = getFavourites
    }
    
    
    
}


