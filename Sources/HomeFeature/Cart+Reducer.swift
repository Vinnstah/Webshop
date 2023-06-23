import ComposableArchitecture
import Foundation
import CartModel
import SiteRouter
import Product

public extension Home {
    
    func cart(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        switch action {
           
        case let .cart(.cartSessionResponse(.success(cart))):
            state.cart = cart
            return .run { send in
                await send(.cart(.cartItemsResponse(
                    TaskResult {
                        try await self.apiClient.decodedResponse(
                            for: .cart(.fetchAllItems(session: cart.session.id.rawValue)),
                                       as: ResultPayload<[Cart.Item]>.self).value.status.get()
                    }
                )))
            }
            
        case let .cart(.cartItemsResponse(.success(items))):
            state.cart?.item = items
            return .run { send in
                await send(.task)
            }
            
        case .cart(.cartItemsResponse(.failure(_))):
            return .none
            
            //TODO: Change UUID creation to server-side and do it directly in DB
        case .cart(.cartSessionResponse(.failure)):
            state.cart?.session = .init(id: .init(rawValue: .init()), jwt: .init(rawValue: ""))
            return .run { send in
                
                await send(.cart(.createCartSessionResponse(
                    TaskResult {
                        try await self.apiClient.decodedResponse(
                            for: .cart(.create(jwt: await self.userDefaultsClient.getLoggedInUserJWT()!)),
                            as: ResultPayload<Cart.Session>.self).value.status.get()
                    }
                )))
            }
        case let .cart(.createCartSessionResponse(.success(session))):
            state.cart?.session = session
            return .none
            
        case .cart(.createCartSessionResponse(.failure(_))):
            print("FAILED to create session")
            return .none
            
        case let .cart(.addProductToCartTapped(quantity: quantity, product: product)):
            
            guard quantity != 0 else {
                return .none
            }
            
            if state.cart!.item.contains(
                where: { $0.id == product.id }
            ) {
                state.cart!.item = state.cart!.item.map {
                    $0.id == product.id ?
                    Cart.Item(
                        id: product.id,
                        quantity: Cart.Item.Quantity(rawValue: quantity))
                    : $0 }
             } else {
                 state.cart?.item.append(Cart.Item(
                    id: product.id,
                    quantity: Cart.Item.Quantity(rawValue: quantity))
                 )
             }
            return .run { [cart = state.cart] send in
                
                await send(.cart(.addProductToCartResponse(
                    TaskResult {
                        try await self.apiClient.decodedResponse(
                            for: .cart(.add(item: cart!)),
                            as: ResultPayload<[Cart.Item]>.self).value.status.get()
                    }
                )))
            }
            
        case let .cart(.addProductToCartResponse(.success(items))):
            guard items == state.cart?.item else {
                return .none
            }
            return .run { send in
                try await self.clock.sleep(for: .milliseconds(500))
                await send(.browse(.delegate(.dismissedDetails)), animation: .easeIn)
            }
            
        case .cart(.addProductToCartResponse(.failure(_))):
            print("FAIL")
            return .none
            
        case let .cart(.removeItemFromCartTapped(id)):
            
            state.cart?.item.removeAll(where: { $0.id == id })
            
            return .run { [item = state.cart!.session.id.rawValue] send in
                await send(.cart(.removeItemFromCartResponse(
                    TaskResult {
                        try await self.apiClient.decodedResponse(
                            for: .cart(.delete(id: item, product: id.rawValue)),
                            as: ResultPayload<Product.ID.RawValue>.self).value.status.get()
                    }
                )))
            }
            
        case let .cart(.removeItemFromCartResponse(.success(id))):
            state.cart?.item.removeAll(
                where: { $0.id.rawValue == id}
            )
            return .run { send in
                await send(.task)
            }
            
        case .cart(.removeItemFromCartResponse(.failure(_))):
            print("FAIL")
            return .none
            

        case .task:
            return .run { [cart = state.cart, text = state.searchText] send in
                guard let cart else {
                    return
                }
                await self.cartStateClient.sendAction(cart)
                try await self.searchClient.sendSearchInput(text)
            }

        case .internal, .delegate, .browse:
            return .none
            
        }
            
    }
}
