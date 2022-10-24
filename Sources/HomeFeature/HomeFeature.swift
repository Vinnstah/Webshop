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
        public var product: Product?
        public var catergories: [ProductModel.Category]
        public var cart: Cart?
        public var quantity: Int
        
        
        public init(
            productList: [Product] = [],
            isProductDetailSheetPresented: Bool = false,
            product: Product? = nil,
            catergories: [ProductModel.Category] = [],
            cart: Cart? = nil,
            quantity: Int = 0
        ) {
            self.productList = productList
            self.isProductDetailSheetPresented = isProductDetailSheetPresented
            self.product = product
            self.catergories = catergories
            self.cart = cart
            self.quantity = quantity
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
            case increaseQuantityButtonPressed
            case decreaseQuantityButtonPressed
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
                state.product = product
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .internal(.toggleSheet):
                state.isProductDetailSheetPresented.toggle()
                return .none
                
            case .delegate(_):
                return .none
                
            case let .internal(.addItemToCart(product, quantity: quantity)):
                guard state.cart != nil else {
                    state.cart = .init(userJWT: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBQzM3MjFBMi03OTUwLTQ3MzUtQkMyNy1GQUVBMzdDMTgyQjkiLCJuYW1lIjoidGVzdGVyQHRlc3Rlci5zZSIsImlhdCI6MTY2NTA4NTczMi41MDkzMX0.qfgtrBqDOCp2FRF6eh9jDKn114BweI6BL9yGd0R3QOk")
                    state.cart?.addItemToCart(product: product, quantity: quantity)
                    return .run { [apiClient, cart = state.cart] send in
    //                    cart?.userJWT = try await userDefaultsClient.getLoggedInUserJWT()
                        await send(.internal(.upsertCartSession(
                            TaskResult {
                                try await apiClient.decodedResponse(
                                    for: .addCartSession(cart!),
                                    as: ResultPayload<String>.self
                                ).value.status.get()
                            })))
                    }
                }
                state.cart?.userJWT = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBQzM3MjFBMi03OTUwLTQ3MzUtQkMyNy1GQUVBMzdDMTgyQjkiLCJuYW1lIjoidGVzdGVyQHRlc3Rlci5zZSIsImlhdCI6MTY2NTA4NTczMi41MDkzMX0.qfgtrBqDOCp2FRF6eh9jDKn114BweI6BL9yGd0R3QOk"
                state.cart?.addItemToCart(product: product, quantity: quantity)
                return .run { [apiClient, cart = state.cart] send in
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
                }
                
            case let .internal(.upsertCartSession(.success(id))):
                return .run { send in
                    print("SUCCSS")
                    
                }
                    
            case .internal(.upsertCartSession(.failure)):
                print("FAIL")
                return .none
            case .internal(.increaseQuantityButtonPressed):
                state.quantity += 1
                return .none
            case .internal(.decreaseQuantityButtonPressed):
                state.quantity -= 1
                return .none
            }
            }
        }
    }


