import ComposableArchitecture
import Foundation
import CartModel
import SiteRouter

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
            return .none
            
        case .cart(.cartItemsResponse(.failure(_))):
            print("NO items found")
            return .none
            
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
            state.cart!.session = session
            return .none
            
        case .cart(.createCartSessionResponse(.failure(_))):
            print("FAILED to create session")
            return .none
            
        case let .cart(.addProductToCartTapped(quantity: quantity, product: product)):
            
            guard quantity != 0 else {
                return .none
            }
            
            if state.cart!.item.contains(
                where: {$0.product == product.id}
            ) {
                state.cart!.item = state.cart!.item.map { $0.product == product.id ?
                    Cart.Item(
                        product: product.id,
                        quantity: Cart.Item.Quantity(rawValue: quantity))
                    : $0 }
             } else {
                 state.cart?.item.append(Cart.Item(
                    product: product.id,
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
            state.quantity = 0
            return .run { send in
                try await self.clock.sleep(for: .milliseconds(500))
                await send(.detailView(.toggleDetailView(nil)), animation: .easeIn)
            }
            
        case .cart(.addProductToCartResponse(.failure(_))):
            print("FAIL")
            return .none
            
        case let .cart(.removeItemFromCartTapped(id)):
            
            state.cart?.item.removeAll(where: { $0.product == id })
            
            return .run { [item = state.cart!.session.id.rawValue] send in
                await send(.cart(.removeItemFromCartResponse(
                    TaskResult {
                        try await self.apiClient.decodedResponse(
                            for: .cart(.delete(id: item, product: id.rawValue)),
                            as: ResultPayload<Cart.Session.ID.RawValue>.self).value.status.get()
                    }
                )))
            }
            
        case .cart(.removeItemFromCartResponse(.success)):
            state.cart?.item.removeAll(
                where: { $0.product == state.product?.id}
            )
            return .none
            
        case .cart(.removeItemFromCartResponse(.failure(_))):
            print("FAIL")
            return .none
            

                        
        case .internal, .delegate, .view, .detailView, .favorite:
            return .none
        }
    }
}
