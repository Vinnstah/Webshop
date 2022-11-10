import Foundation
import ComposableArchitecture
import SwiftUI
import HomeFeature
import FavoriteFeature
import CheckoutFeature
import CartModel
import ApiClient
import SiteRouter
import Product

public struct Main: ReducerProtocol, Sendable {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.mainQueue) var mainQueue
    public init() {}
}

public extension Main {
    struct State: Equatable, Sendable {
        public var selectedTab: Tab
        public var home: Home.State?
        public var favorites: Favorites.State?
        public var checkout: Checkout.State?
        
        
        public init(
            selectedTab: Tab = .home
        ) {
            
            self.selectedTab = selectedTab
            self.home = .init()
            self.favorites = .init()
            self.checkout = .init()
        }
        
        public enum Tab: Equatable, Sendable {
            case home
            case favorites
            case settings
            case checkout
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        case home(Home.Action)
        case favorites(Favorites.Action)
        case checkout(Checkout.Action)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsLoggedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case onAppear
            case tabSelected
            case getCartSession(TaskResult<Cart>)
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
                    case .favorites: state.favorites = .init()
                    case .settings: return .none
                    case .checkout: return .none
                }
                return .none
                
            case .internal(.onAppear):
//                let cart: Cart = Cart(id: Cart.ID.init(rawValue: .init()), item: [Cart.Item(product: Product.ID(rawValue: .init()), quantity: Cart.Quantity(rawValue: 4))], jwt: Cart.JWT(rawValue: "TEST124fafaffaf34"))
                return .run { send in
                    await send(.internal(.getCartSession(
                    TaskResult {
                        try await self.apiClient.decodedResponse(
                            for: .cart(.fetch(id: "TEST1234")),
                            as: ResultPayload<Cart>.self).value.status.get()
                    }
                )))
                }
                
            case let .internal(.getCartSession(.success(test))):
                print(test)
                return .none
                
            case let .internal(.getCartSession(.failure(_))):
                print("FAIL")
                return .none
                
            case .delegate(_):
                return .none
            case .home(_):
                return .none
            case .internal(_):
                return .none
            case .favorites(_):
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
            \State.favorites,
             action: /Action.favorites
        ) {
            Favorites()
        }
        .ifLet(
            \State.checkout,
             action: /Action.checkout
        ) {
            Checkout()
        }
        
    }
    
}



