import Foundation
import ComposableArchitecture
import SiteRouter
import Product

public extension Browse {
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
                //MARK: OnAppear API call
            case .internal(.onAppear):
                return .run { send in
                    await send(.internal(.getAllProductsResponse(
                        TaskResult {
                            try await self.apiClient.decodedResponse(
                                for: .products(.fetch),
                                as: ResultPayload<[Product]>.self).value.status.get()
                        }
                    )))
                    
                    await send(.favorite(.loadFavoriteProducts(
                        try self.favouritesClient.getFavourites()
                    )))
                    
                }
                
            case .task:
                print("TASK?")
                return .run { send in
                    for try await value in try await self.cartStateClient.observeAction() {
                        print("value \(value)")
                        guard let value else {
                            return
                        }
                        await send(.internal(.cartValueResponse(value)))
                    }
                }
                
            case let .internal(.cartValueResponse(cart)):
                print("SUCCESS \(cart)")
                state.cart = cart
                return .none
                
            case let .internal(.getAllProductsResponse(.success(products))):
                state.products = IdentifiedArray(uniqueElements: products)
                return .none
                
            case let .internal(.getAllProductsResponse(.failure(error))):
                print(error.localizedDescription)
                return .none
                
                
            case let .view(.categoryButtonTapped(category)):
                switch category {
                
                case .strategy:
                    state.products = state.products.filter( { $0.boardgame.category.rawValue == "Strategy"})
                case .classics:
                    state.products = state.products.filter( { $0.boardgame.category.rawValue == "Classics"})
                case .children:
                    state.products = state.products.filter( { $0.boardgame.category.rawValue == "Children"})
                case .scifi:
                    state.products = state.products.filter( { $0.boardgame.category.rawValue == "Sci-fi"})
                }
                return .none
                
                //MARK: StaggeredGrid column actions
            case .view(.increaseNumberOfColumnsTapped):
                state.columnsInGrid += 1
                return .none
                
            case .view(.decreaseNumberOfColumnsTapped):
                guard state.columnsInGrid > 1 else {
                    return .none
                }
                state.columnsInGrid -= 1
                return .none
                
//            case .delegate(.dismissedDetails):
//                state.selectedProduct = nil
//                return .none
                
//            case let .view(.selectedProduct(prod)):
//                guard state.selectedProduct == nil else {
//                    state.selectedProduct = nil
//                    return .none
//                }
//                state.selectedProduct = prod
//                return .none
                
            case .view, .delegate, .internal, .favorite, .detail:
                return .none
            }
        }
    }
}
