import Foundation
import ComposableArchitecture
import ProductModel
import ApiClient
import SiteRouter
import UserDefaultsClient

//TODO: Remove entire feature and replace with favorites
public struct Favorites: ReducerProtocol, Sendable {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    public init() {}
}

public extension Favorites {
    struct State: Equatable, Sendable {
        public var productList: [Product]
        public var searchText: String
        public var searchResults: [Product]
        public var isProductDetailSheetPresented: Bool
        public var productDetailView: Product?
        public var quantity: Int
        public var favoriteProducts: FavoriteProducts
        
        public init(
            productList: [Product] = [],
            searchText: String = "",
            searchResults: [Product] = [],
            isProductDetailSheetPresented: Bool = false,
            productDetailView: Product? = nil,
            quantity: Int = 1,
            favoriteProducts: FavoriteProducts = .init()
        ) {
            self.productList = productList
            self.searchText = searchText
            self.searchResults = searchResults
            self.isProductDetailSheetPresented = isProductDetailSheetPresented
            self.productDetailView = productDetailView
            self.quantity = quantity
            self.favoriteProducts = favoriteProducts
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
            case addProductToCart(quantity: Int, product: Product)
        }
        
        public enum InternalAction: Equatable, Sendable {
            case onAppear
            case getProductResponse(TaskResult<[Product]>)
            case searchTextReceivesInput(String)
            case showProductDetailViewFor(Product)
            case toggleSheet
            case loadFavoriteProducts([String?])
            case favoriteButtonClicked(Product)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .internal(.onAppear):
                return .run { [apiClient] send in
                    return await send(.internal(.getProductResponse(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .getProducts,
                                as: ResultPayload<[Product]>.self).value.status.get()
                        }
                    )))
                    
                }
                
            case let .internal(.getProductResponse(.success(products))):
                state.productList = products
                return .run { send in
                    await send(.internal(.loadFavoriteProducts(await userDefaultsClient.getFavoriteProducts())))
                    
                }
                
            case let .internal(.loadFavoriteProducts(products)):
                guard !products.isEmpty else {
                        return .none
                    }
                    
                state.favoriteProducts.sku = products
                state.productList = state.productList.filter { state.favoriteProducts.sku.contains($0.sku) }
                return .none
                
            case let .internal(.getProductResponse(.failure(error))):
                print(error)
                return .none
                
            case let .internal(.searchTextReceivesInput(text)):
                state.searchText = text
                state.searchResults = state.productList.filter { $0.title.contains(text)  }
                return .none
                
            case let .internal(.showProductDetailViewFor(product)):
                state.productDetailView = product
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .internal(.toggleSheet):
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case let .internal(.favoriteButtonClicked(product)):
                
                if state.favoriteProducts.sku.contains(product.sku) {
                    print("REMOVE PRODUCT")
                    return .run { [userDefaultsClient, favoriteProducts = state.favoriteProducts.sku] send in
                        await userDefaultsClient.removeFavoriteProduct(product.sku, favoriteProducts: favoriteProducts)
                        await send(.internal(.onAppear))
                    }
                }
                
                return .none
//                print("DONT REMOVE PRODUCT")
//                return .run { [userDefaultsClient] send in
//                    await userDefaultsClient.setFavoriteProduct(product.sku)
//                }
                
            case .delegate(_):
                return .none
            }
        }
    }
}


