import Foundation
import ComposableArchitecture
import SwiftUI
import ProductModel
import UserDefaultsClient
import ApiClient
import SiteRouter
import CartModel
import FavoritesClient

public struct Home: ReducerProtocol, Sendable {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.favouritesClient) var favouritesClient
    public init() {}
}

public extension Home {
    struct State: Equatable, Sendable {
        public var productList: [Product]
        public var product: Product?
        public var catergories: [ProductModel.Category]
        public var cart: Cart?
        public var quantity: Int
        public var searchText: String
        public var searchResults: [Product]
        public var favoriteProducts: FavoriteProducts
        public var isSettingsSheetPresented: Bool
        
        
        public init(
            productList: [Product] = [],
            product: Product? = nil,
            catergories: [ProductModel.Category] = [],
            cart: Cart? = nil,
            quantity: Int = 0,
            searchText: String = "",
            searchResults: [Product] = [],
            favoriteProducts: FavoriteProducts = .init(),
            isSettingsSheetPresented: Bool = false
        ) {
            self.productList = productList
            self.product = product
            self.catergories = catergories
            self.cart = cart
            self.quantity = quantity
            self.searchText = searchText
            self.searchResults = searchResults
            self.favoriteProducts = favoriteProducts
            self.isSettingsSheetPresented = isSettingsSheetPresented
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsLoggedOut
            case addProductToCart(quantity: Int, product: Product)
        }
        
        public enum InternalAction: Equatable, Sendable {
            case logOutUser
            case onAppear
            case getProductResponse(TaskResult<[Product]>)
            case toggleSettingsSheet
            case getCategoryResponse(TaskResult<[ProductModel.Category]>)
            case increaseQuantityButtonPressed
            case decreaseQuantityButtonPressed
            case searchTextReceivesInput(String)
            case favoriteButtonClicked(Product)
            case loadFavoriteProducts([Product.SKU]?)
            case removeFavouriteProduct(Product.SKU?)
            case addFavouriteProduct(Product.SKU?)
            case cancelSearchClicked
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .internal(.logOutUser):
                return .run { [userDefaultsClient] send in
                    await userDefaultsClient.removeLoggedInUserJWT()
                    await send(.delegate(.userIsLoggedOut))
                }
                
                //MARK: On appear API calls
            case .internal(.onAppear):
                return .run { [apiClient] send in
                    await send(.internal(.getProductResponse(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .getProducts,
                                as: ResultPayload<[Product]>.self).value.status.get()
                        }
                    )))
                    
                    await send(.internal(.getCategoryResponse(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .getCategories,
                                as: ResultPayload<[ProductModel.Category]>.self
                            ).value.status.get()
                        }
                    )))
                    
                        await send(.internal(.loadFavoriteProducts(try favouritesClient.getFavourites())))
                }
                
            case let .internal(.getProductResponse(.success(products))):
                state.productList = products
                return .none
                
            case let .internal(.getProductResponse(.failure(error))):
                print(error)
                return .none
                
            case let .internal(.getCategoryResponse(.success(categories))):
                state.catergories = categories
                return .none
                
            case let .internal(.getCategoryResponse(.failure(error))):
                print(error)
                return .none
                
                //MARK: Search function
            case let .internal(.searchTextReceivesInput(text)):
                state.searchText = text
                
                state.searchResults = state.productList.filter { $0.title.contains(text) }
                
                if state.searchResults == [] {
                    state.searchResults = state.productList.filter { $0.category.contains(text) }
                }
                return .none
                
            case .internal(.cancelSearchClicked):
                state.searchText = ""
                state.searchResults = []
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
            case let .internal(.loadFavoriteProducts(products)):
                guard let products else {
                        return .none
                    }
                    
                state.favoriteProducts.sku = products
                return .none
                
            case let .internal(.favoriteButtonClicked(product)):
                
                if state.favoriteProducts.sku.contains(product.sku) {
                    return .run { send in
                        await send(.internal(.removeFavouriteProduct(try favouritesClient.removeFavorite(product.sku))))
                        
                    }
                }
                return .run { send in
                    await send(.internal(.addFavouriteProduct(try favouritesClient.addFavorite(product.sku))))
                }
                
            case let .internal(.removeFavouriteProduct(sku)):
                guard let sku else {
                    return .none
                }
                state.favoriteProducts.sku.removeAll(where: { $0 == sku })
                return .none
                
            case let .internal(.addFavouriteProduct(sku)):
                guard let sku else {
                    return .none
                }
                state.favoriteProducts.sku.append(sku)
                return .none
                
                
            case .delegate(_):
                return .none
                
            }
            }
        }
    }
