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

extension IdentifiedArrayOf: @unchecked Sendable {}

public struct Home: ReducerProtocol, Sendable {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.favouritesClient) var favouritesClient
    public init() {}
}

public extension Home {
    struct State: Equatable, Sendable {
        public var products: IdentifiedArrayOf<Product>
        public var boardgames: IdentifiedArrayOf<Boardgame>
        
        public var product: Product?
        public var catergories: Boardgame.Category?
        public var cart: Cart?
        public var quantity: Int
        public var searchText: String
        public var filteredProducts: IdentifiedArrayOf<Product>
        public var favoriteProducts: FavoriteProducts
        public var isSettingsSheetPresented: Bool
        public var columnsInGrid: Int
        public var showDetailView: Bool
        public var showCheckoutQuickView: Bool
        
        public init(
            products: IdentifiedArrayOf<Product> = [],
            boardgames: IdentifiedArrayOf<Boardgame> = [],
            product: Product? = nil,
            catergories: Boardgame.Category? = nil,
            cart: Cart? = nil,
            quantity: Int = 0, //ViewState
            searchText: String = "",
            filteredProducts: IdentifiedArrayOf<Product> = [],
            favoriteProducts: FavoriteProducts = .init(),
            isSettingsSheetPresented: Bool = false,
            columnsInGrid: Int = 2, // ViewState
            showDetailView: Bool = false,
            showCheckoutQuickView: Bool = false
        ) {
            self.products = products
            self.boardgames = boardgames
            self.product = product
            self.catergories = catergories
            self.cart = cart
            self.quantity = quantity
            self.searchText = searchText
            self.filteredProducts = filteredProducts
            self.favoriteProducts = favoriteProducts
            self.isSettingsSheetPresented = isSettingsSheetPresented
            self.columnsInGrid = columnsInGrid
            self.showDetailView = showDetailView
            self.showCheckoutQuickView = showCheckoutQuickView
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        case favorite(FavoriteAction)
        case view(ViewAction)
        case detailView(DetailViewAction)
        case cart(CartAction)
        
        public enum CartAction: Equatable, Sendable {
            case cartSessionResponse(TaskResult<Cart>)
            case cartItemsResponse(TaskResult<[Cart.Item]>)
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsSignedOut
            case addProductToCart(quantity: Int, product: Product)
        }
        
        public enum FavoriteAction: Equatable, Sendable {
            case favoriteButtonTapped(Product)
            case loadFavoriteProducts([Product.ID]?)
            case removeFavouriteProduct(Product.ID?)
            case addFavouriteProduct(Product.ID?)
        }
        
        public enum InternalAction: Equatable, Sendable {
            case getAllProductsResponse(TaskResult<[Product]>)
            case signOutTapped
            case onAppear
            case settingsButtonTapped
            case searchTextReceivingInput(text: String)
            case cancelSearchTapped
            case categoryButtonTapped(Boardgame.Category)
            case toggleCheckoutQuickViewTapped
            case createCartSession(TaskResult<String>)
        }
        
        public enum DetailViewAction: Equatable, Sendable {
            case toggleDetailView(Product?)
            case increaseQuantityButtonTapped
            case decreaseQuantityButtonTapped
        }
        
        public enum ViewAction: Equatable, Sendable {
            case increaseNumberOfColumnsTapped
            case decreaseNumberOfColumnsTapped
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        CombineReducers {
            Reduce(favorite.self)
            
        Reduce { state, action in
            switch action {
                
            case .internal(.signOutTapped):
                return .run { [userDefaultsClient] send in
                    await userDefaultsClient.removeLoggedInUserJWT()
                    await send(.delegate(.userIsSignedOut))
                }
                
                //MARK: On appear API calls
            case .internal(.onAppear):
                return .run { send in
                    await send(.internal(.getAllProductsResponse(
                        TaskResult {
                            try await self.apiClient.decodedResponse(
                                for: .products(.fetch),
                                as: ResultPayload<[Product]>.self).value.status.get()
                        }
                    )))
                    
                    await send(.favorite(.loadFavoriteProducts(try self.favouritesClient.getFavourites())))
                    
                    await send(.cart(.cartSessionResponse(
                        TaskResult {
                            try await self.apiClient.decodedResponse(
                                for: .cart(.fetch(jwt: await self.userDefaultsClient.getLoggedInUserJWT() ?? "")),
                                as: ResultPayload<Cart>.self).value.status.get()
                    }
                                                         )))
                }
                
            case let .cart(.cartSessionResponse(.success(cart))):
                state.cart = cart
                print("cart")
                return .run { send in
                    await send(.cart(.cartItemsResponse(
                        TaskResult {
                            try await self.apiClient.decodedResponse(
                                for: .cart(.fetchAllItems(session: cart.session.id.rawValue)),
                                           as: ResultPayload<[Cart.Item]>.self).value.status.get()
                        }
                    )))
                }
                
            case let .cart(.cartItemsResponse(.success(items))):
//                print(items)
                state.cart?.item = items
                return .none
                
            case .cart(.cartItemsResponse(.failure(_))):
                print("NO items found")
                return .none
                
            case .cart(.cartSessionResponse(.failure(_))):
                print("NO Session found")
                return .none
                    
            case let .internal(.getAllProductsResponse(.success(products))):
                state.products = IdentifiedArray(uniqueElements: products)
                return .none
                
            case .internal(.getAllProductsResponse(.failure(_))):
                print("FAIL")
                return .none
                
            case let .internal(.createCartSession(.success(test))):
                return .none
                
                //MARK: Search function
            case let .internal(.searchTextReceivingInput(text: text)):
                state.searchText = text
                
                state.filteredProducts = state.products.filter { $0.boardgame.title.contains(text) }
                
                if state.filteredProducts == [] {
                    state.filteredProducts = state.products.filter { $0.boardgame.category.rawValue.contains(text) }
                }
                return .none
                
            case .internal(.cancelSearchTapped):
                state.searchText = ""
                state.filteredProducts = []
                return .none
                
            case .internal(.settingsButtonTapped):
                state.isSettingsSheetPresented.toggle()
                return .none
                
            case .detailView(.increaseQuantityButtonTapped):
                state.quantity += 1
                return .none
                
            case .detailView(.decreaseQuantityButtonTapped):
                guard state.quantity != 0 else {
                    return .none
                }
                state.quantity -= 1
                return .none
                
            case .delegate(_):
                return .none
                
            case let .internal(.categoryButtonTapped(category)):
                switch category {
                case .strategy:
                    state.filteredProducts = state.products.filter(
                        { $0.boardgame.category.rawValue == "Strategy"}
                    )
                case .classics:
                    state.filteredProducts = state.products.filter({ $0.boardgame.category.rawValue == "Classics"})
                case .children:
                    state.filteredProducts = state.products.filter({ $0.boardgame.category.rawValue == "Children"})
                case .scifi:
                    state.filteredProducts = state.products.filter({ $0.boardgame.category.rawValue == "Sci-fi"})
                }
                return .none
                
                //MARK: StaggeredGrid column actions
            case .view(.increaseNumberOfColumnsTapped):
                state.columnsInGrid += 1
                return .none
                
            case .view(.decreaseNumberOfColumnsTapped):
                guard state.columnsInGrid > 1 else {
                    return .none
                }
                state.columnsInGrid -= 1
                return .none
                
            case let .detailView(.toggleDetailView(prod)):
                guard prod != nil else {
                    state.product =  nil
                    state.showDetailView.toggle()
                    return .none
                }
                state.product = prod
                state.showDetailView.toggle()
                return .none
                
            case .internal(.toggleCheckoutQuickViewTapped):
                state.showCheckoutQuickView.toggle()
                return .none
            case .internal(.createCartSession(.failure(_))):
                print("ERROR")
                return .none
                
            case .favorite:
                return .none
            }
            }
        }
    }
}
