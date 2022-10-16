import Foundation
import ComposableArchitecture
import SwiftUI
import HomeFeature
import ProductsFeature

public struct Main: ReducerProtocol {
    public init() {}
}

public extension Main {
    struct State: Equatable, Sendable {
        
        public var selectedTab: Tab
        public var home: Home.State?
        public var products: Products.State?
        
        public init(
            selectedTab: Tab = .home,
            home: Home.State? = .init(),
            products: Products.State? = .init()
        ) {
            
            self.selectedTab = selectedTab
            self.home = home
            self.products = products
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
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsLoggedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case tabSelected
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
//        Scope(state: \State.home, action: /Action.home) {
//            Home()
//        }
//        Scope(state: \State.products, action: /Action.products) {
//            Products()
//        }
//    }
        Reduce { state, action in
            switch action {
            case .home(.delegate(.userIsLoggedOut)):
                return .run { send in
                    await send(.delegate(.userIsLoggedOut))
                }
            case.internal(.tabSelected):
                switch state.selectedTab {
                case .home: state.home = .init()
                case .products: state.products = .init()
                case .settings:
                    return .none
                case .checkout:
                    return .none
                }
                return .none
            
            case .delegate(_):
                return .none
            case .home(_):
                return .none
            case .internal(_):
                return .none
            case .products(_):
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
//        .ifCaseLet(
//            /State.products,
//             action: /Action.products
//        ) {
//            Products()
    }
    
}



