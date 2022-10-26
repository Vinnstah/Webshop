import Foundation
import ComposableArchitecture
import SwiftUI
import HomeFeature
import ProductsFeature
import CheckoutFeature
import CartModel
import ApiClient
import SiteRouter
import ProductModel

public struct Main: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.mainQueue) var mainQueue
    public init() {}
}

public extension Main {
    struct State: Equatable, Sendable {
        public var selectedTab: Tab
        public var home: Home.State?
        public var products: Products.State?
        public var checkout: Checkout.State?
        public var cart: Cart
        
        
        public init(
            selectedTab: Tab = .home,
            cart: Cart
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
            case onAppear
            case tabSelected
            case addOrUpdateCartSession(TaskResult<String>)
            case getDatabaseSessions(TaskResult<[Cart.Session]>)
            case addProductsToCart(TaskResult<String>)
            case getProductsFromCartSession(TaskResult<Cart>)
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
                state.cart.addItemToCart(product: product, quantity: quantity)
                return .run { [apiClient, cart = state.cart] send in
                    await send(.internal(.addOrUpdateCartSession(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .addShoppingCartItems(cart),
                                as: ResultPayload<String>.self
                            ).value.status.get()
                        }
                    )))
                }
                
                
            case .internal(.addOrUpdateCartSession(.success)):
                
                state.checkout?.cart = state.cart
                return .none
                    
            case .internal(.addOrUpdateCartSession(.failure)):
                print("FAIL")
                return .none
                
            case let .internal(.getDatabaseSessions(.success(sessions))):
                for session in sessions {
                    if state.cart.userJWT == session.jwt {
                        state.cart.id = session.id
                        state.cart.session = .init(id: session.id, jwt: session.jwt, dbID: session.dbID)
                    }
                }
                
                guard state.cart.session != nil else {
                    return .run { [apiClient, cart = state.cart] send in
                        await send(.internal(.addOrUpdateCartSession(
                            TaskResult {
                                try await apiClient.decodedResponse(
                                    for: .addCartSession(cart),
                                    as: ResultPayload<String>.self
                                ).value.status.get()
                            }
                        )
                        )
                        )
                    }
                }
                
                
                print("SESSION UPDATED")
                return .run { [apiClient, id = state.cart.id] send in
                    await send(.internal(.getProductsFromCartSession(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .shoppingCartSessionProducts(id: id),
                                as: ResultPayload<Cart>.self
                            ).value.status.get()
                        }
                    )
                    )
                    )
                }
                
            case let .internal(.getProductsFromCartSession(.success(cart))):
                let session = state.cart.session
                state.cart = cart
                state.cart.session = session
                state.checkout?.cart = state.cart
                return .none
                
            case .internal(.getProductsFromCartSession(.failure)):
                print("FAILED TO GET PRODUCTS FROM SESSION")
                return .none
                
            case .internal(.getDatabaseSessions(.failure)):
                print("FAILED TO GET DB SESSIONS")
                return .none
                
            case .internal(.onAppear):
                return .run { [apiClient] send in
                    await send(.internal(.getDatabaseSessions(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .shoppingSessionDatabaseID,
                                as: ResultPayload<[Cart.Session]>.self
                            ).value.status.get()
                        }
                    )))
                }
                
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



