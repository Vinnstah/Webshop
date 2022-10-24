import Foundation
import ComposableArchitecture
import ProductModel
import ApiClient
import SiteRouter

//TODO: Remove entire feature and replace with favorites
public struct Products: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    public init() {}
}

public extension Products {
    struct State: Equatable, Sendable {
        public var productList: [Product]
        public var searchText: String
        public var searchResults: [Product]
        public var isProductDetailSheetPresented: Bool
        public var productDetailView: Product?
        public var quantity: Int
        
        public init(
            productList: [Product] = [],
            searchText: String = "",
            searchResults: [Product] = [],
            isProductDetailSheetPresented: Bool = false,
            productDetailView: Product? = nil,
            quantity: Int = 1
        ) {
            self.productList = productList
            self.searchText = searchText
            self.searchResults = searchResults
            self.isProductDetailSheetPresented = isProductDetailSheetPresented
            self.productDetailView = productDetailView
            self.quantity = quantity
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
                
            case .delegate(_):
                return .none
            }
        }
    }
}


