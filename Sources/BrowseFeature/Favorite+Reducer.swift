import ComposableArchitecture
import Foundation
import FavoritesClient

public extension Browse {
    
    func favorite(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        switch action {
        case let .favorite(.loadFavoriteProducts(products)):
            guard !products.isEmpty else {
                return .none
            }
            
            state.favoriteProducts.ids = products
            return .none
            
        case let .favorite(.favoriteButtonTapped(product)):
            
            guard !state.favoriteProducts.ids.contains(product.id) else {
                return .run { send in
                    await send(.favorite(.removeFavouriteProduct(try self.favouritesClient.removeFavorite(product.id)!)))
                }
            }
            
            return .run { send in
                await send(.favorite(.addFavouriteProduct(try self.favouritesClient.addFavorite(product.id)!)))
            }
            
        case let .favorite(.removeFavouriteProduct(sku)):
            state.favoriteProducts.ids.removeAll(where: { $0 == sku })
            return .none
            
        case let .favorite(.addFavouriteProduct(sku)):
            state.favoriteProducts.ids.append(sku)
            return .none
            
        case .internal, .delegate, .view, .task, .detail:
            return .none
        }
    }
}
