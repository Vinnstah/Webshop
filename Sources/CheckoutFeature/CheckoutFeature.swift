import Foundation
import CartModel
import ComposableArchitecture
import ApiClient
import Product
import Dependencies
import SiteRouter
import UserDefaultsClient

public struct Checkout: ReducerProtocol, Sendable {
    public init() {}
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.userDefaultsClient) var userDefaultsClient
}

public extension Checkout {
    struct State: Equatable, Sendable {
        public var cart: Cart?
        public var items: [Cart.Item]
        public var products: IdentifiedArrayOf<Product>
        
        //
        public init(
            cart: Cart? = nil,
            items: [Cart.Item] = [],
            products: IdentifiedArrayOf<Product> = []
            
        ) {
            self.cart = cart
            self.items = items
            self.products = products
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
        }
        
        public enum InternalAction: Equatable, Sendable {
            case onAppear
            case getCartItems(TaskResult<[Cart.Item]>)
            case getCartSession(TaskResult<Cart>)
            case getAllProdcuts(TaskResult<[Product]>)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .internal(.onAppear):
                
                return .run { send in
                    await send(.internal(.getCartSession(
                        TaskResult {
                            try await self.apiClient.decodedResponse(
                                for: .cart(.fetch(jwt: await self.userDefaultsClient.getLoggedInUserJWT()!)),
                                as: ResultPayload<Cart>.self).value.status.get()
                        }
                    )))
                    
                    await send(.internal(.getAllProdcuts(
                        TaskResult {
                            try await self.apiClient.decodedResponse(
                                for: .products(.fetch),
                                as: ResultPayload<[Product]>.self).value.status.get()
                        })))
                }
                
            case let .internal(.getCartSession(.success(cart))):
                state.cart = cart
                return .run { [session = state.cart!.session.id] send in
                    await send(.internal(.getCartItems(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .cart(.fetchAllItems(session: session.rawValue)),
                                as: ResultPayload<[Cart.Item]>.self).value.status.get()
                        })))
                }
                
            case let .internal(.getCartItems(.success(items))):
                state.items = items
                return .none
                
            case let .internal(.getAllProdcuts(.success(products))):
                state.products.append(contentsOf: products)
                return .none
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
                
            }
        }
    }
}



