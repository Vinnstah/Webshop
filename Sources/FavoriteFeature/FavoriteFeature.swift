import Foundation
import ComposableArchitecture
import Product
import ApiClient
import SiteRouter
import FavoritesClient

extension IdentifiedArrayOf: @unchecked Sendable {}

public struct Favorites: ReducerProtocol, Sendable {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.favouritesClient) var favouritesClient
    public init() {}
}

public extension Favorites {
    struct State: Equatable, Sendable {
        public var productList: IdentifiedArrayOf<Product>
        public var searchText: String
        public var searchResults: [Product]
        public var isProductDetailSheetPresented: Bool
        public var productDetailView: Product?
        public var quantity: Int
        public var favoriteProducts: FavoriteProducts
        
        public init(
            productList: IdentifiedArrayOf<Product> = [],
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
            case loadFavoriteProducts([Product.ID]?)
            case favoriteButtonClicked(Product)
            case removeFavouriteProduct(Product.ID?)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .internal(.onAppear):
                return .run { [apiClient] send in
                    await send(.internal(.loadFavoriteProducts(try favouritesClient.getFavourites())))
                    return await send(.internal(.getProductResponse(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .products(.fetch),
                                as: ResultPayload<[Product]>.self).value.status.get()
                        }
                    )))
                }
                
            case let .internal(.getProductResponse(.success(products))):
                state.productList = IdentifiedArray(uniqueElements: products)
                return .run { send in
                    await send(.internal(.loadFavoriteProducts(try favouritesClient.getFavourites())))
                }
                
            case let .internal(.loadFavoriteProducts(products)):
                guard let products else {
                        return .none
                    }
                    
                state.favoriteProducts.ids = products
                state.productList = state.productList.filter { state.favoriteProducts.ids.contains($0.id) }
                return .none
                
            case let .internal(.getProductResponse(.failure(error))):
                print(error)
                return .none
                
            case let .internal(.searchTextReceivesInput(text)):
                state.searchText = text
                state.searchResults = state.productList.filter { $0.boardgame.title.contains(text)  }
                return .none
                
            case let .internal(.showProductDetailViewFor(product)):
                state.productDetailView = product
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .internal(.toggleSheet):
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case let .internal(.favoriteButtonClicked(product)):
                
                if state.favoriteProducts.ids.contains(product.id) {
                    return .run { send in
                        await send(.internal(.removeFavouriteProduct(try favouritesClient.removeFavorite(product.id))))
                    }
                }
                return .none
                
            case let .internal(.removeFavouriteProduct(sku)):
                guard let sku else {
                    return .none
                }
                state.productList.removeAll(where: { $0.id == sku })
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}


