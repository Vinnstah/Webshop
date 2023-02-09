import Foundation
import ComposableArchitecture
import Boardgame
import Product
import FavoritesClient
import ApiClient
import Dependencies
import SharedCartStateClient
import CartModel
import DetailFeature
import SearchClient

public struct Browse: ReducerProtocol, Sendable {
    public init() {}
    @Dependency(\.favouritesClient) var favouritesClient
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.cartStateClient) var cartStateClient
    @Dependency(\.continuousClock) var clock
    @Dependency(\.searchClient) var searchClient
}

public extension Browse {
    struct State: Equatable {
        public var categories: IdentifiedArrayOf<Boardgame.Category>
        public var products: IdentifiedArrayOf<Product>
        public var filteredProducts: Set<Product.ID>
        public var favoriteProducts: FavoriteProducts
        public var columnsInGrid: Int
        public var detail: Detail.State?
        public var cart: Cart?
        public var searchString: String
        public var searchResults: IdentifiedArrayOf<Product>
        
        public init(
            categories: IdentifiedArrayOf<Boardgame.Category> = IdentifiedArray(uniqueElements: Boardgame.Category.allCases),
            products: IdentifiedArrayOf<Product> = [],
            filteredProducts: Set<Product.ID> = [],
            favoriteProducts: FavoriteProducts = .init(),
            columnsInGrid: Int = 2,
            detail: Detail.State? = nil,
            cart: Cart? = nil,
            searchString: String = "",
            searchResults: IdentifiedArrayOf<Product> = []
        ) {
            self.categories = categories
            self.products = products
            self.filteredProducts = filteredProducts
            self.favoriteProducts = favoriteProducts
            self.columnsInGrid = columnsInGrid
            self.detail = detail
            self.cart = cart
            self.searchString = searchString
            self.searchResults = searchResults
        }
    }
}
