import Foundation
import ComposableArchitecture
import SwiftUI
import HomeFeature
import FavoriteFeature
import CheckoutFeature
import CartModel
import Product

public struct Main: ReducerProtocol, Sendable {
    public init() {}
}

public extension Main {
    struct State: Equatable, Sendable {
        
        //        public var selectedTab: Tab
        public var home: Identified<Tab, Home.State>
        public var favorites: Identified<Tab, Favorites.State>
        public var checkout: Identified<Tab, Checkout.State>
        @BindableState var selectedTab: Tab
        
        public init(
            selectedTab: Tab = .home
        ) {
            self.selectedTab = .home
            self.home = .init(.init(), id: .home)
            self.favorites = .init(.init(), id: .favorites)
            self.checkout = .init(.init(), id: .checkout)
        }
        
        public enum Tab: Equatable, Sendable {
            case home
            case favorites
            case checkout
        }
    }
    
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        case home(Home.Action)
        case favorites(Favorites.Action)
        case checkout(Checkout.Action)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsSignedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case tabSelected
            case selectTab(State.Tab)
        }
    }
    var body: some ReducerProtocol<State, Action> {
        CombineReducers {
            BindingReducer<State, Action>()
            Scope(state: \State.home.value, action: /Action.home) {
                Home()
            }
            Scope(state: \State.favorites.value, action: /Action.favorites) {
                Favorites()
            }
            Scope(state: \State.checkout.value, action: /Action.checkout) {
                Checkout()
            }
            Reduce { state, action in
                switch action {
                    
                case .home(.delegate(.userIsSignedOut)):
                    return .run { send in
                        await send(.delegate(.userIsSignedOut))
                    }
                    
                case let .internal(.selectTab(tab)):
                    state.selectedTab = tab
                    return .none
                    
                case .binding(\.$selectedTab):
                    print(state.selectedTab)
                    return .none
                    //                case .internal(.tabSelected):
                    //                    switch state.selectedTab {
                    //                    case .home: state.home = .init()
                    //                    case .favorites: state.favorites = .init()
                    //                    case .checkout: return .none
                    //                    }
                    //                    return .none
                default:
                    return .none
                    //            case .delegate, .home, .internal, .favorites, .checkout, .binding:
                    //                return .none
                }
            }
            
        }
        //        .ifLet(
        //            \State.home,
        //             action: /Action.home
        //        ) {
        //            Home()
        //        }
        //        .ifLet(
        //            \State.favorites,
        //             action: /Action.favorites
        //        ) {
        //            Favorites()
        //        }
        //        .ifLet(
        //            \State.checkout,
        //             action: /Action.checkout
        //        ) {
        //            Checkout()
        //        }
        
    }
    
}
