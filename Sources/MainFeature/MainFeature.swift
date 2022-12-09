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
        
        public var internalState: InternalState
        public var selectedTab: Tab
        public var home: Home.State?
        public var favorites: Favorites.State?
        public var checkout: Checkout.State?
        
        public init(
            internalState: InternalState = .init(),
            selectedTab: Tab = .home
        ) {
            self.internalState = internalState
            self.selectedTab = selectedTab
            self.home = .init()
            self.favorites = .init()
            self.checkout = .init()
        }
        
        public struct InternalState: Equatable, Sendable {
            public var showDetailView: Bool
            public var searchText: String
            public var favoriteProducts: FavoriteProducts?
            public var isCartEmpty: Bool
            public var product: Product?
            public var productList: IdentifiedArrayOf<Product>
            
            public init(
        showDetailView: Bool = false,
        searchText: String = "",
        favoriteProducts: FavoriteProducts? = nil,
        isCartEmpty: Bool = true,
        product: Product? = nil,
        productList: IdentifiedArrayOf<Product> = []
            ) {
                self.showDetailView = showDetailView
                self.searchText = searchText
                self.favoriteProducts = favoriteProducts
                self.isCartEmpty = isCartEmpty
                self.product = product
                self.productList = productList
            }
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
            
            case settingsButtonTapped
            case toggleDetailView(Product?)
            case searchTextReceivingInput(text: String)
            case cancelSearchTapped
            case addFavouriteProduct(Product.ID)
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

public extension Main {
    func `internal`(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case let .internal(.searchTextReceivingInput(text: text)):
            state.internalState.searchText = text
            return .none
            
        case let .internal(.toggleDetailView(product)):
            guard let product else {
                return .none
            }
            
            state.internalState.showDetailView.toggle()
            state.internalState.product = product
            
            return .none
            
        case .internal(.cancelSearchTapped):
            state.internalState.searchText = ""
            return .none
            
        case .internal(.settingsButtonTapped):
            return .none
            
        case let .internal(.addFavouriteProduct(id)):
            state.internalState.favoriteProducts?.sku.append(id)
            return .none
            
        case .internal(_):
            return .none
            
        case .delegate, .home, .favorites, .checkout:
            return .none
        }
    }
}
