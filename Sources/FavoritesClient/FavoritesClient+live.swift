
import Foundation
import UserDefaultsClient
import ComposableArchitecture
import ProductModel


public extension FavoritesClient {
    
    static let live: Self = {
        let userDefaults = UserDefaults()
        
        let favouritesKey = "favouritesKey"
        
        @Sendable func mutatingFavourites(_ mutate: ( inout [Product.SKU]) throws -> Void) throws -> Product.SKU? {
            var currentUserDefaultsData: Data? = userDefaults.data(forKey: favouritesKey)
            
            guard let currentUserDefaultsData else {
                var favourites: Favourites = .init(favourites: [])
                try mutate(&favourites.favourites)
                
                let encodedFavourites = try JSONEncoder().encode(favourites)
                userDefaults.set(encodedFavourites, forKey: favouritesKey)
                
                return favourites.favourites.first
            }
            
            var decodedData = try JSONDecoder().decode(Favourites.self, from: currentUserDefaultsData)
            var favourites = decodedData
            try mutate(&favourites.favourites)
            
            guard !decodedData.favourites.contains(where: {
                sku in
                favourites.favourites.first(where: { $0 == sku }) == sku
            } ) else {
                return nil
            }
            let encodedFavourites = try JSONEncoder().encode(favourites)
            userDefaults.set(encodedFavourites, forKey: favouritesKey)
            
            return favourites.favourites.filter { !decodedData.favourites.contains($0)}.first
            
        }
        
        
        return Self.init(addFavorite: { sku in
            try mutatingFavourites { favourites in
                favourites.append(sku)
            }
        },
                         removeFavorite: { sku in
            try mutatingFavourites { favourites in
                favourites.removeAll(where: { $0 == sku })
            }
            
        }
        )
    }()
}
