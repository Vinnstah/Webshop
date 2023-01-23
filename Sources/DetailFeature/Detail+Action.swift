import ComposableArchitecture
import Foundation
import Product
import CartModel

public extension Detail {
    enum Action: Equatable, Sendable {
        case detailView(DetailViewAction)
        case delegate(DelegateAction)
        case task
        
        public enum DelegateAction: Equatable, Sendable {
            case removedItemFromCart(Product.ID)
            case addedItemToCart(quantity: Int, product: Product)
            case toggleFavourite
            case backToBrowse
        }
        
        public enum DetailViewAction: Equatable, Sendable {
            case increaseQuantityButtonTapped
            case decreaseQuantityButtonTapped
            case addItemToCartTapped(quantity: Int, product: Product)
            case removeItemFromCartTapped(Product.ID)
            case toggleFavouriteButtonTapped
            case cartValueResponse(Cart)
        }
    }
}
