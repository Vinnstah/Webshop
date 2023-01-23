import ComposableArchitecture
import Foundation
import Product
import CartModel
import SharedCartStateClient

public struct Detail: Sendable, ReducerProtocol {
    @Dependency(\.cartStateClient) var cartStateClient
    public init() {}
}

public extension Detail {
    struct State: Equatable, Sendable {
        public var selectedProduct: Product
        public var cartItems: IdentifiedArrayOf<Cart.Item>
        public var quantity: Int
        public var isFavourite: Bool
        
        public init(
            selectedProduct: Product,
            cartItems: IdentifiedArrayOf<Cart.Item> = [],
            quantity: Int = 0,
            isFavourite: Bool = false
        ) {
            self.selectedProduct = selectedProduct
            self.cartItems = cartItems
            self.quantity = quantity
            self.isFavourite = isFavourite
        }
        
    }
}
