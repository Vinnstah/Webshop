
import Foundation
import UserDefaultsClient
import ComposableArchitecture
import ProductModel


public extension FavoritesClient {
    
    static let live: Self = {
        let userDefaults = UserDefaults()
        
        let favouritesKey = "favouritesKey"
        
        func mutatingFavourites(_ mutate: (inout [Product.SKU]) throws -> Product.SKU?) throws -> Product.SKU? {
            var favorites: [Product.SKU] = []
            let mutatedArray = try mutate(&favorites)
            let encoded = try JSONEncoder().encode(mutatedArray)
            userDefaults.set(encoded, forKey: favouritesKey)
            return favorites.first
        }
        
        let addFavourite: (Product.SKU?) throws -> Product.SKU? = { sku in
            return try mutatingFavourites { favourites in
                var existingData: Data? = userDefaults.data(forKey: favouritesKey)
                var favourites = try existingData.map { try JSONDecoder().decode(Favourites.self, from: $0) } ?? Favourites.init(favourites: [])
                guard !(favourites.favourites.contains(where: { $0 ==  sku }) ) else { return Product.SKU.init(rawValue: "") }
                favourites.favourites.append(sku ?? .init(rawValue: "TEST"))
                return sku
            }
            return sku
        }
        
        return Self.init(addFavorite: addFavourite)
        
    }()
}
