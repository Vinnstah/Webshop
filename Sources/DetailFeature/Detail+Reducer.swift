import ComposableArchitecture
import Foundation

public extension Detail {
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .detailView(.increaseQuantityButtonTapped):
                state.quantity = state.quantity + 1
                return .none
                
            case .detailView(.decreaseQuantityButtonTapped):
                guard state.quantity != 0 else {
                    return .none
                }
                state.quantity -= 1
                return .none
                
            case let .detailView(.addItemToCartTapped(quantity: quantity, product: product)):
                return .run { send in
                    await send(.delegate(.addedItemToCart(quantity: quantity, product: product)))
                }
                
            case let .detailView(.removeItemFromCartTapped(id)):
                return .run { send in
                    await send(.delegate(.removedItemFromCart(id)))
                }
                
            case .task:
                return .run { send in
                    for try await value in try await self.cartStateClient.observeAction() {
                        guard let value else {
                            print("VLAUE \(value)")
                            return
                        }
                        print("VAVAVA \(value)")
                        await send(.detailView(.cartValueResponse(value)))
                    }
                }
                
            case let .detailView(.cartValueResponse(cart)):
                print("CARVA:TA")
                state.cartItems = IdentifiedArrayOf(uniqueElements: cart.item)
                return .none
                
                
            case .detailView, .delegate:
                return .none
            }
        }
    }
}
