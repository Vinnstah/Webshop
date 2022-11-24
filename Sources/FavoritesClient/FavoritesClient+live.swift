import Foundation
import UserDefaultsClient
import ComposableArchitecture
import Product
import JSONClients

public extension FavoritesClient {
    
    static let live: Self = {
        
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
