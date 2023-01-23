import Foundation
import ComposableArchitecture
import SwiftUI
import Product
import UserDefaultsClient
import ApiClient
import SiteRouter
import CartModel
import FavoritesClient
import Boardgame
import Warehouse
import BrowseFeature
import SharedCartStateClient

extension IdentifiedArrayOf: @unchecked Sendable {}

public struct Home: ReducerProtocol, Sendable {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.favouritesClient) var favouritesClient
    @Dependency(\.continuousClock) var clock
    @Dependency(\.cartStateClient) var cartStateClient
    public init() {}
}

public extension Home {
    struct State: Equatable, Sendable {
        public var browse: Browse.State
        public var cart: Cart?
        public var searchText: String
        public var isSettingsSheetPresented: Bool
        public var showCheckoutQuickView: Bool
        
        public init(
            browse: Browse.State = .init(),
            cart: Cart? = nil,
            searchText: String = "",
            isSettingsSheetPresented: Bool = false,
            showCheckoutQuickView: Bool = false
        ) {
            self.browse = browse
            self.cart = cart
            self.searchText = searchText
            self.isSettingsSheetPresented = isSettingsSheetPresented
            self.showCheckoutQuickView = showCheckoutQuickView
        }
    }
    
    
    //Split into 3 cases, `child`, `internal` and `delegate`
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
//        case child(ChildAction)
        case delegate(DelegateAction)
        case browse(Browse.Action)
        case task
        case cart(CartAction)
        
//        public enum ChildAction: Equatable, Sendable {
//            case browse(Browse.Action)
//        }
        public enum CartAction: Equatable, Sendable {
            case cartSessionResponse(TaskResult<Cart>)
            case cartItemsResponse(TaskResult<[Cart.Item]>)
            case createCartSessionResponse(TaskResult<Cart.Session>)
            case addProductToCartTapped(quantity: Int, product: Product)
            case addProductToCartResponse(TaskResult<[Cart.Item]>)
            case removeItemFromCartTapped(Product.ID)
            case removeItemFromCartResponse(TaskResult<Product.ID.RawValue>)
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsSignedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case signOutTapped
            case onAppear
            case settingsButtonTapped
//            case searchTextReceivingInput(text: String)
//            case cancelSearchTapped
            case toggleCheckoutQuickViewTapped
        }
        
        
    }
    
    var body: some ReducerProtocol<State, Action> {
        CombineReducers {
            
            Scope(state: \.browse, action: /Action.browse) {
                Browse()
            }
            Reduce { state, action in
                switch action {
                    
                case .internal(.signOutTapped):
                    return .run { send in
                        await self.userDefaultsClient.removeLoggedInUserJWT()
                        await send(.delegate(.userIsSignedOut))
                    }
                    
                    //MARK: On appear API calls
                case .internal(.onAppear):
                    return .run { send in
                        await send(.cart(.cartSessionResponse(
                            TaskResult {
                                try await self.apiClient.decodedResponse(
                                    for: .cart(.fetch(jwt: await self.userDefaultsClient.getLoggedInUserJWT()!)),
                                    as: ResultPayload<Cart>.self).value.status.get()
                            }
                        )))
                    }
                case let .browse(.delegate(.addedItemToCart(quantity: quantity, product: product))):
                    return .run { send in
                           await send(.cart(.addProductToCartTapped(quantity: quantity, product: product)))
                    }
                    
                case let .browse(.delegate(.removedItemFromCart(id))):
                    print("234")
                    return .run { send in
                        await send(.cart(.removeItemFromCartTapped(id)))
                    }
                    
                    //MARK: Search function
//                case let .internal(.searchTextReceivingInput(text: text)):
//                    state.searchText = text
//
//                    state.child.browse.filteredProducts = state.products.filter { $0.boardgame.title.contains(text) }
//
//                    if state.filteredProducts == [] {
//                        state.filteredProducts = state.products.filter { $0.boardgame.category.rawValue.contains(text) }
//                    }
//                    return .none
//
//                case .internal(.cancelSearchTapped):
//                    state.searchText = ""
//                    state.filteredProducts = []
//                    return .none
                    
                case .internal(.settingsButtonTapped):
                    state.isSettingsSheetPresented.toggle()
                    return .none
                    
                case .internal(.toggleCheckoutQuickViewTapped):
                    state.showCheckoutQuickView.toggle()
                    return .none
                    
                case .cart, .delegate, .browse, .task:
                    return .none
                }
            }
            
            Reduce(cart.self)
        }
    }
}
