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
        public var isProductDetailSheetPresented: Bool
        public var product: Product?
        public var catergories: [ProductModel.Category]
        public var cart: Cart?
        public var quantity: Int
        public var searchText: String
        public var searchResults: [Product]
        
        
        public init(
            productList: [Product] = [],
            isProductDetailSheetPresented: Bool = false,
            product: Product? = nil,
            catergories: [ProductModel.Category] = [],
            cart: Cart? = nil,
            quantity: Int = 0,
            searchText: String = "",
            searchResults: [Product] = []
        ) {
            self.productList = productList
            self.isProductDetailSheetPresented = isProductDetailSheetPresented
            self.product = product
            self.catergories = catergories
            self.cart = cart
            self.quantity = quantity
            self.searchText = searchText
            self.searchResults = searchResults
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
            case toggleSheet
            case showProductDetailViewFor(Product)
            case getCategoryResponse(TaskResult<[ProductModel.Category]>)
            case increaseQuantityButtonPressed
            case decreaseQuantityButtonPressed
            case searchTextReceivesInput(String)
            case favoriteButtonClicked(Product)
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
                }
                
            case let .internal(.searchTextReceivesInput(text)):
                state.searchText = text
                state.searchResults = state.productList.filter { $0.title.contains(text)  }
                return .none
                
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
                
            case let .internal(.showProductDetailViewFor(product)):
                state.product = product
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .internal(.toggleSheet):
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .internal(.increaseQuantityButtonPressed):
                state.quantity += 1
                return .none
                
            case .internal(.decreaseQuantityButtonPressed):
                state.quantity -= 1
                return .none
                
            case let .internal(.favoriteButtonClicked(product)):
                return .run { send in
                    try favouritesClient.addFavorite(product.sku)
                }
                
            case .delegate(_):
                return .none
                
            }
            }
        }
    }
