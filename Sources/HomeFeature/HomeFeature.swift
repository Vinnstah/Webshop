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

extension IdentifiedArrayOf: @unchecked  Sendable {}

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
        
        public var productList: [Product]
        public var product: Product?
        public var catergories: Boardgame.Category?
        public var cart: Cart?
        public var quantity: Int
        public var searchText: String
        public var filteredProducts: [Product]
        public var favoriteProducts: FavoriteProducts
        public var isSettingsSheetPresented: Bool
        public var columnsInGrid: Int
        public var showDetailView: Bool
        public var showCheckoutQuickView: Bool
        
        public init(
            products: IdentifiedArrayOf<Product> = [],
            boardgames: IdentifiedArrayOf<Boardgame> = [],
            productList: [Product] = [],
            product: Product? = nil,
            catergories: Boardgame.Category? = nil,
            cart: Cart? = nil,
            quantity: Int = 0,
            searchText: String = "",
            filteredProducts: [Product] = [],
            favoriteProducts: FavoriteProducts = .init(),
            isSettingsSheetPresented: Bool = false,
            columnsInGrid: Int = 2,
            showDetailView: Bool = false,
            showCheckoutQuickView: Bool = false
        ) {
            self.products = products
            self.boardgames = boardgames
            self.productList = productList
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
        case boardgame(BoardgameAction)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsSignedOut
            case addProductToCart(quantity: Int, product: Product)
        }
        
        public enum FavoriteAction: Equatable, Sendable {
            case favoriteButtonClicked(Product)
            case loadFavoriteProducts([Product.ID]?)
            case removeFavouriteProduct(Product.ID?)
            case addFavouriteProduct(Product.ID?)
        }
        
        public enum BoardgameAction: Equatable, Sendable {
            case getFetchBoardgamesResponse(TaskResult<[Boardgame]>)
        }
        
        public enum InternalAction: Equatable, Sendable {
            case logOutUser
            case onAppear
            case getProductResponse(TaskResult<[Product]>)
            case toggleSettingsSheet
            case increaseQuantityButtonPressed
            case decreaseQuantityButtonPressed
            case searchTextReceivesInput(String)
            case cancelSearchClicked
            case categoryButtonPressed(Boardgame.Category)
            case increaseNumberOfColumns
            case decreaseNumberOfColumns
            case toggleDetailView(Product?)
            case toggleCheckoutQuickView
            
            case createCartSession(TaskResult<String>)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .internal(.logOutUser):
                return .run { [userDefaultsClient] send in
                    await userDefaultsClient.removeLoggedInUserJWT()
                    await send(.delegate(.userIsSignedOut))
                }
                
                //MARK: On appear API calls
            case .internal(.onAppear):
                return .run { [apiClient] send in
                    await send(.boardgame(.getFetchBoardgamesResponse(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .boardgame(.fetch),
                                as: ResultPayload<[Boardgame]>.self).value.status.get()
                        }
                    )))
                    
//                    await send(.internal(.createCartSession(
//                        TaskResult {
//                            try await self.apiClient.decodedResponse(
//                                for: .cart(.create(cart)),
//                                as: ResultPayload<String>.self).value.status.get()
//                        }
//                    )))
                }
                //
                //                        await send(.internal(.loadFavoriteProducts(try favouritesClient.getFavourites())))
                //                }
            case let .internal(.createCartSession(.success(test))):
                return .none
                
            case let .boardgame(.getFetchBoardgamesResponse(.success(boardgames))):
                print(boardgames)
                state.boardgames = IdentifiedArray(uniqueElements: boardgames)
                state.products = IdentifiedArray(uniqueElements: Product(boardgame: boardgames.first!, price: .init(brutto: 1, currency: .sek), id: Product.ID(rawValue: UUID()) ?? UUID()))
                //                    state.productList = products
                return .none
                
            case let .boardgame(.getFetchBoardgamesResponse(.failure(error))):
                print(error)
                return .none
                
                
            case let .internal(.getProductResponse(.success(products))):
                state.productList = products
                return .none
                
            case let .internal(.getProductResponse(.failure(error))):
                print(error)
                return .none
                
                
                //MARK: Search function
            case let .internal(.searchTextReceivesInput(text)):
                state.searchText = text
                
                state.filteredProducts = state.productList.filter { $0.boardgame.title.contains(text) }
                
                if state.filteredProducts == [] {
                    state.filteredProducts = state.productList.filter { $0.boardgame.category.rawValue.contains(text) }
                }
                return .none
                
            case .internal(.cancelSearchClicked):
                state.searchText = ""
                state.filteredProducts = []
                return .none
                
                //MARK: Misc actions
            case .internal(.toggleSettingsSheet):
                state.isSettingsSheetPresented.toggle()
                return .none
                
            case .internal(.increaseQuantityButtonPressed):
                state.quantity += 1
                return .none
                
            case .internal(.decreaseQuantityButtonPressed):
                guard state.quantity != 0 else {
                    return .none
                }
                state.quantity -= 1
                return .none
                
                //MARK: Favourite interaction
            case let .favorite(.loadFavoriteProducts(products)):
                guard let products else {
                    return .none
                }
                
                state.favoriteProducts.sku = products
                return .none
                
            case let .favorite(.favoriteButtonClicked(product)):
                
                if state.favoriteProducts.sku.contains(product.id) {
                    return .run { send in
                        await send(.favorite(.removeFavouriteProduct(try favouritesClient.removeFavorite(product.id))))
                        
                    }
                }
                return .run { send in
                    await send(.favorite(.addFavouriteProduct(try favouritesClient.addFavorite(product.id))))
                }
                
            case let .favorite(.removeFavouriteProduct(sku)):
                guard let sku else {
                    return .none
                }
                state.favoriteProducts.sku.removeAll(where: { $0 == sku })
                return .none
                
            case let .favorite(.addFavouriteProduct(sku)):
                guard let sku else {
                    return .none
                }
                state.favoriteProducts.sku.append(sku)
                return .none
                
                
            case .delegate(_):
                return .none
                
            case let .internal(.categoryButtonPressed(category)):
                switch category {
                case .strategy:
                    state.filteredProducts = state.productList.filter(
                        { $0.boardgame.category.rawValue == "Strategy"}
                    )
                case .classics:
                    state.filteredProducts = state.productList.filter({ $0.boardgame.category.rawValue == "Classics"})
                case .children:
                    state.filteredProducts = state.productList.filter({ $0.boardgame.category.rawValue == "Children"})
                case .scifi:
                    state.filteredProducts = state.productList.filter({ $0.boardgame.category.rawValue == "Sci-fi"})
                }
                return .none
                
                //MARK: StaggeredGrid column actions
            case .internal(.increaseNumberOfColumns):
                state.columnsInGrid += 1
                return .none
                
            case .internal(.decreaseNumberOfColumns):
                guard state.columnsInGrid > 1 else {
                    return .none
                }
                state.columnsInGrid -= 1
                return .none
                
            case let .internal(.toggleDetailView(prod)):
                guard prod != nil else {
                    state.product =  nil
                    state.showDetailView.toggle()
                    return .none
                }
                state.product = prod
                state.showDetailView.toggle()
                return .none
                
            case .internal(.toggleCheckoutQuickView):
                state.showCheckoutQuickView.toggle()
                return .none
            case .internal(.createCartSession(.failure(_))):
                print("ERROR")
                return .none
            }
        }
    }
}
