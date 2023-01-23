import ComposableArchitecture
import Foundation

public extension Detail {
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .detailView(.increaseQuantityButtonTapped):
                return .none
                
            case .detailView(.decreaseQuantityButtonTapped):
//                guard state.quantity != 0 else {
//                    return .none
//                }
//                state.quantity -= 1
                return .none
                
            case let .detailView(.addItemToCartTapped(quantity: quantity, product: product)):
//                state.selectedProduct = nil
                return .run { send in
                    await send(.delegate(.addedItemToCart(quantity: quantity, product: product)))
                }
                
            case let .detailView(.removeItemFromCartTapped(id)):
                return .run { send in
                    await send(.delegate(.removedItemFromCart(id)))
                }
                
            default: return .none
            }
        }
    }
}
