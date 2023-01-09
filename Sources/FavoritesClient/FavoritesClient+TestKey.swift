import Dependencies
import Foundation

#if DEBUG
import XCTestDynamicOverlay

extension FavoritesClient {
    public static let test = Self(
        addFavorite:  unimplemented("\(AddFavorite.self)") ,
        removeFavorite: unimplemented("\(RemoveFavorite.self)"),
        getFavourites: unimplemented("\(GetFavourites.self)")
    )
}

extension FavoritesClient: TestDependencyKey {
    public static let testValue = FavoritesClient.test
}
#endif // DEBUG

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

public extension DependencyValues {
    var favouritesClient: FavoritesClient {
        get { self[FavoritesClient.self] }
        set { self[FavoritesClient.self] = newValue }
    }
}
