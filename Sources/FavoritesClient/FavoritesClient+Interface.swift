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
    
    public typealias AddFavorite = @Sendable (Product.ID) async throws -> Product.ID?
    public typealias RemoveFavorite = @Sendable (Product.ID) async throws -> Product.ID?
    public typealias GetFavourites = @Sendable () async throws -> [Product.ID]
    
    public var addFavorite: AddFavorite
    public var removeFavorite: RemoveFavorite
    public var getFavourites: GetFavourites
}


