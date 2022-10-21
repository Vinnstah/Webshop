import Foundation
import ComposableArchitecture
import SwiftUI
import ProductModel
import UserDefaultsClient
import ApiClient
import SiteRouter

public struct Home: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.apiClient) var apiClient
    public init() {}
}

public extension Home {
    struct State: Equatable, Sendable {
        public var productList: [Product]
        public var isProductDetailSheetPresented: Bool
        public var productDetailView: Product?
        public var catergories: Set<String>
        
        public init(
            productList: [Product] = [],
            isProductDetailSheetPresented: Bool = false,
            productDetailView: Product? = nil,
            catergories: Set<String> = []
        ) {
            self.productList = productList
            self.isProductDetailSheetPresented = isProductDetailSheetPresented
            self.productDetailView = productDetailView
            self.catergories = catergories
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsLoggedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case logOutUser
            case onAppear
            case getProductResponse(TaskResult<[Product]>)
            case toggleSheet
            case showProductDetailViewFor(Product)
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
                
                state.productList.forEach { prod in
                    if state.catergories.contains(prod.category)  {
                        return
                    }
                    state.catergories.insert(prod.category)
                }
//                state.catergories = state.catergories.append
                return .none
                
            case let .internal(.getProductResponse(.failure(error))):
                print(error)
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


