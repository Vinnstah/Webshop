import Foundation
import ComposableArchitecture
import SwiftUI
import ProductModel
import UserDefaultsClient
import ApiClient
import SiteRouter
import CartModel

public struct Home: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.apiClient) var apiClient
    public init() {}
}

public extension Home {
    struct State: Equatable, Sendable {
        public var productList: [Product]
        public var isProductDetailSheetPresented: Bool
        public var productShownInDetailView: Product?
        public var catergories: [ProductModel.Category]
        public var cart: Cart?
        
        
        public init(
            productList: [Product] = [],
            isProductDetailSheetPresented: Bool = false,
            productShownInDetailView: Product? = nil,
            catergories: [ProductModel.Category] = [],
            cart: Cart? = nil
        ) {
            self.productList = productList
            self.isProductDetailSheetPresented = isProductDetailSheetPresented
            self.productShownInDetailView = productShownInDetailView
            self.catergories = catergories
            self.cart = cart
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
            case addItemToCart(Product, quantity: Int)
            case upsertCartSession(TaskResult<String>)
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
                                as: ResultPayload<[ProductModel.Category]>.self).value.status.get()
                        }
                    )))
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
                
            case let .internal(.showProductDetailViewFor(product)):
                state.productShownInDetailView = product
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .internal(.toggleSheet):
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .delegate(_):
                return .none
                
            case let .internal(.addItemToCart(product, quantity: quantity)):
                state.cart = .init()
//                state.cart?.addItemToCart(product: product, quantity: quantity)
                return .run { [apiClient, userDefaultsClient, cart = state.cart] send in
                    print("UPSERT TESTING")
                    await send(.internal(.upsertCartSession(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .addCartSession(cart!),
                                as: ResultPayload<String>.self
                            ).value.status.get()
                        }
                    )
                    )
                    )
//                    await send(.delegate(.addProductToCart(quantity: quantity, product: product)))
                }
                
            case let .internal(.upsertCartSession(.success(id))):
                return .run { send in
                    print("SUCCSS")
                    
                }
                    
            case .internal(.upsertCartSession(.failure)):
                print("FAIL")
                return .none
            }
            }
        }
    }


