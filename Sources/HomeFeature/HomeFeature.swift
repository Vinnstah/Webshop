import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel
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
        
        public init(productList: [Product] = []) {
            self.productList = productList
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
                return .none
                
            case let .internal(.getProductResponse(.failure(error))):
                print(error)
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}


