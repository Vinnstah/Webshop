import ComposableArchitecture
import Foundation
import FavoritesClient

public extension Home {
    
    func favorite(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        switch action {
        case let .favorite(.loadFavoriteProducts(products)):
            guard let products else {
                return .none
            }
            
            state.favoriteProducts.sku = products
            return .none
            
        case let .favorite(.favoriteButtonClicked(product)):
            
            if state.favoriteProducts.sku.contains(product.id) {
                return .run { send in
                    await send(.favorite(.removeFavouriteProduct(try self.favouritesClient.removeFavorite(product.id))))
                    
                }
            }
            return .run { send in
                await send(.favorite(.addFavouriteProduct(try self.favouritesClient.addFavorite(product.id))))
            }
            
        case let .favorite(.removeFavouriteProduct(sku)):
            guard let sku else {
                return .none
            }
            state.favoriteProducts.sku.removeAll(where: { $0 == sku })
            return .none
            
        case let .favorite(.addFavouriteProduct(sku)):
            guard let sku else {
                return .none
            }
            state.favoriteProducts.sku.append(sku)
            return .none
            
        case .internal, .delegate, .view, .detailView:
            return .none
        }
    }
}
