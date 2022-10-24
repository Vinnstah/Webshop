import Foundation
import ComposableArchitecture
import SwiftUI
import HomeFeature
import ProductsFeature
import CheckoutFeature
import CartModel
import ApiClient
import SiteRouter

public struct Main: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    public init() {}
}

public extension Main {
    struct State: Equatable, Sendable {
        
//        public var selectedTab: Tab
//        public var home: Home.State?
//        public var products: Products.State?
//        public var checkout: Checkout.State?
//        public var cart: Cart?
//
//
//        public init(
//            selectedTab: Tab = .home,
//            home: Home.State? = .init(),
//            products: Products.State? = .init(),
//            checkout: Checkout.State? = .init(),
//            cart: Cart? = nil
//        ) {
//
//            self.selectedTab = selectedTab
//            self.home = home
//            self.products = products
//            self.checkout = checkout
//            self.cart = cart
//        }
        public var selectedTab: Tab
        public var home: Home.State?
        public var products: Products.State?
        public var checkout: Checkout.State?
        public var cart: Cart?
        
        
        public init(
            selectedTab: Tab = .home,
            cart: Cart? = nil
        ) {
            
            self.selectedTab = selectedTab
            self.home = .init()
            self.products = .init()
            self.checkout = .init(cart: cart)
            self.cart = cart
        }
        
        public enum Tab: Equatable, Sendable {
            case home
            case products
            case settings
            case checkout
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        case home(Home.Action)
        case products(Products.Action)
        case checkout(Checkout.Action)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsLoggedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case tabSelected
            case upsertCartSession(TaskResult<String>)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .home(.delegate(.userIsLoggedOut)):
                return .run { send in
                    await send(.delegate(.userIsLoggedOut))
                }
            case .internal(.tabSelected):
                switch state.selectedTab {
                case .home: state.home = .init()
                case .products: state.products = .init()
                case .settings:
                    return .none
                case .checkout: state.checkout?.cart = state.cart
                }
                return .none
                
            case let .home(.delegate(.addProductToCart(quantity: quantity, product: product))):
                guard state.cart != nil else {
                    state.cart = .init(userJWT: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBQzM3MjFBMi03OTUwLTQ3MzUtQkMyNy1GQUVBMzdDMTgyQjkiLCJuYW1lIjoidGVzdGVyQHRlc3Rlci5zZSIsImlhdCI6MTY2NTA4NTczMi41MDkzMX0.qfgtrBqDOCp2FRF6eh9jDKn114BweI6BL9yGd0R3QOk")
                    state.cart?.addItemToCart(product: product, quantity: quantity)
                    return .run { [apiClient, cart = state.cart] send in
    //                    cart?.userJWT = try await userDefaultsClient.getLoggedInUserJWT()
                        await send(.internal(.upsertCartSession(
                            TaskResult {
                                try await apiClient.decodedResponse(
                                    for: .addCartSession(cart!),
                                    as: ResultPayload<String>.self
                                ).value.status.get()
                            })))
                    }
                }
                state.cart?.userJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBQzM3MjFBMi03OTUwLTQ3MzUtQkMyNy1GQUVBMzdDMTgyQjkiLCJuYW1lIjoidGVzdGVyQHRlc3Rlci5zZSIsImlhdCI6MTY2NTA4NTczMi41MDkzMX0.qfgtrBqDOCp2FRF6eh9jDKn114BweI6BL9yGd0R3QOk"
                state.cart?.addItemToCart(product: product, quantity: quantity)
                return .run { [apiClient, cart = state.cart] send in
                    await send(.internal(.upsertCartSession(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .addCartSession(cart!),
                                as: ResultPayload<String>.self
                            ).value.status.get()
                        }
                    )
                    )
                    )
                }
//                state.cart = state.cart?.addItemToCart(product: Product, quantity: <#T##Int#>)
//                state.checkout = .init(cart: state.cart)
//                return .none
            case let .internal(.upsertCartSession(.success(id))):
                print(state.cart)
                return .run { send in
                    print("SUCCSS")
                    
                }
                    
            case .internal(.upsertCartSession(.failure)):
                print("FAIL")
                return .none
                
            case .delegate(_):
                return .none
            case .home(_):
                return .none
            case .internal(_):
                return .none
            case .products(_):
                return .none
            case .checkout(_):
                return .none
                
            }
            
                
        }
        .ifLet(
            \State.home,
             action: /Action.home
        ) {
            Home()
        }
        .ifLet(
            \State.products,
             action: /Action.products
        ) {
            Products()
        }
        .ifLet(
            \State.checkout,
             action: /Action.checkout
        ) {
            Checkout()
        }
        
    }
    
}



