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
            case userIsSignedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case onAppear
            case tabSelected
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .home(.delegate(.userIsSignedOut)):
                return .run { send in
                    await send(.delegate(.userIsSignedOut))
                }
                
            case .internal(.tabSelected):
                switch state.selectedTab {
                    case .home: state.home = .init()
                    case .favorites: state.favorites = .init()
                    case .settings: return .none
                    case .checkout: return .none
                }
                return .none
                
            case .delegate, .home, .internal, .favorites, .checkout:
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



