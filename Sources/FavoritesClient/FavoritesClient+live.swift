import Foundation
import UserDefaultsClient
import Dependencies
import Product
import JSONClients

extension FavoritesClient: DependencyKey {
    
    public static let liveValue: Self = {
        
        @Dependency(\.userDefaultsClient) var userDefaultsClient
        @Dependency(\.jsonDecoder) var jsonDecoder
        @Dependency(\.jsonEncoder) var jsonEncoder
        
        let favouritesKey = "favouritesKey"
        
        @Sendable func mutatingFavourites(_ mutate: ( inout [Product.ID]) throws -> Void) async throws -> Product.ID? {
            var currentUserDefaultsData: Data? = await userDefaultsClient.dataForKey(favouritesKey)
            
            var decodedData: Favourites = try currentUserDefaultsData.map { try jsonDecoder().decode(Favourites.self, from: $0) } ?? .init(favourites: [])
            
            var favourites = decodedData
            
            try mutate(&favourites.favourites)
            let difference = favourites.favourites.difference(from: decodedData.favourites)
            guard difference != [] else {
                return nil
            }
            
            let encodedFavourites = try jsonEncoder().encode(favourites)
            await userDefaultsClient.setData(encodedFavourites, favouritesKey)
            
            return difference.first
        }
        
        
        return Self.init(addFavorite: { sku in
            try await mutatingFavourites { favourites in
                favourites.append(sku)
            }
        },
                         removeFavorite: { sku in
            try await mutatingFavourites { favourites in
                favourites.removeAll(where: { $0 == sku })
            }
            
        },
                         getFavourites: {
            var currentUserDefaultsData: Data? = await userDefaultsClient.dataForKey(favouritesKey)
            guard let currentUserDefaultsData else {
                return []
            }
            var decodedData = try jsonDecoder().decode(Favourites.self, from: currentUserDefaultsData)
            return decodedData.favourites
        }
        )
    }()
}
