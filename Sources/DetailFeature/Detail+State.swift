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
    struct State: Equatable {
        public var selectedProduct: Product
        public var cart: Cart?
        public var quantity: Int
        public var isFavourite: Bool
        
        public init(
            selectedProduct: Product,
            cart: Cart? = nil,
            quantity: Int,
            isFavourite: Bool
        ) {
            self.selectedProduct = selectedProduct
            self.cart = cart
            self.quantity = quantity
            self.isFavourite = isFavourite
        }
        
    }
}
