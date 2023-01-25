import Foundation
import SwiftUI
import Product
import ComposableArchitecture
import Boardgame
import CartModel
import DetailFeature

public extension Browse {
    enum Action: Equatable, Sendable {
        case view(ViewAction)
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        case favorite(FavoriteAction)
        case detail(Detail.Action)
        case task
        
        public enum FavoriteAction: Equatable, Sendable {
            case favoriteButtonTapped(Product)
            case loadFavoriteProducts([Product.ID])
            case removeFavouriteProduct(Product.ID)
            case addFavouriteProduct(Product.ID)
        }

        public enum InternalAction: Equatable, Sendable {
            case onAppear
            case getAllProductsResponse(TaskResult<[Product]>)
            case cartValueResponse(Cart)
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case dismissedDetails
            case removedItemFromCart(Product.ID)
            case addedItemToCart(quantity: Int, product: Product)
        }
        

        
        public enum ViewAction: Equatable, Sendable {
            case categoryButtonTapped(Boardgame.Category)
            case selectedProduct(Product, Namespace.ID)
            case increaseNumberOfColumnsTapped
            case decreaseNumberOfColumnsTapped
        }
    }
}
