
import Foundation
import UserDefaultsClient
import ComposableArchitecture
import Product

public extension FavoritesClient {
    
    static let live: Self = {
        let userDefaults = UserDefaults()
        
        let favouritesKey = "favouritesKey"
        
        @Sendable func mutatingFavourites(_ mutate: ( inout [Product.ID]) throws -> Void) throws -> Product.ID? {
            var currentUserDefaultsData: Data? = userDefaults.data(forKey: favouritesKey)
            
            var decodedData: Favourites = try currentUserDefaultsData.map { try JSONDecoder().decode(Favourites.self, from: $0) } ?? .init(favourites: [])
            
            var favourites = decodedData
            
            try mutate(&favourites.favourites)
            let difference = favourites.favourites.difference(from: decodedData.favourites)
            guard difference != [] else {
                return nil
            }
            
            let encodedFavourites = try JSONEncoder().encode(favourites)
            userDefaults.set(encodedFavourites, forKey: favouritesKey)
            
            return difference.first
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
            
        },
                         getFavourites: {
            var currentUserDefaultsData: Data? = userDefaults.data(forKey: favouritesKey)
            guard let currentUserDefaultsData else {
                return []
            }
            var decodedData = try JSONDecoder().decode(Favourites.self, from: currentUserDefaultsData)
            return decodedData.favourites
        }
        )
    }()
}

extension FavoritesClient {
    public static let unimplemented = Self(
        addFavorite: { _ in return nil },
        removeFavorite: { _ in return nil},
        getFavourites: {  return nil }
    )
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

private enum FavoritesClientKey: DependencyKey {
    typealias Value = FavoritesClient
    static let liveValue = FavoritesClient.live
    static let testValue = FavoritesClient.unimplemented
}
public extension DependencyValues {
    var favouritesClient: FavoritesClient {
        get { self[FavoritesClientKey.self] }
        set { self[FavoritesClientKey.self] = newValue }
    }
}
