import Foundation
import ComposableArchitecture
import UserModel
import ApiClient
import SiteRouter

public struct Products: ReducerProtocol {
    @Dependency(\.apiClient) var apiClient
    public init() {}
}

public extension Products {
    struct State: Equatable, Sendable {
        public var productList: [Product]
        public var searchText: String
        
        public init(
            productList: [Product] = [],
            searchText: String = ""
        ) {
            self.productList = productList
            self.searchText = searchText
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
        }
        
        public enum InternalAction: Equatable, Sendable {
            case onAppear
            case getProductResponse(TaskResult<[Product]>)
            case searchTextReceivesInput(String)
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
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}


