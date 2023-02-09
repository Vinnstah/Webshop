import Foundation
import ComposableArchitecture
import SiteRouter
import Product
import DetailFeature

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
                    return .run { send in
                        await withThrowingTaskGroup(of: Void.self) { group in
                            group.addTask {
                                for try await value in try await self.cartStateClient.observeAction() {
                                    guard let value else {
                                        return
                                    }
                                    await send(.internal(.cartValueResponse(value)))
                                }
                            }
                            group.addTask {
                                for try await searchValue in try await self.searchClient.observeSearchInput() {
                                    await send(.internal(.searchValueResponse(searchValue)))
                                }
                            }
                        }
                    }
                    
                case let .internal(.cartValueResponse(cart)):
                    state.cart = cart
                    return .none
                    
                case let .internal(.searchValueResponse(text)):
                    guard text != "" else {
                        state.searchResults = []
                        return .none
                    }
                    state.searchResults = state.products.filter { $0.boardgame.title.contains(text) }
                    
                    guard state.searchResults != [] else {
                        state.searchResults = state.products.filter { $0.boardgame.category.rawValue.contains(text) }
                        return .none
                    }
                    return .none
                    
                case let .internal(.getAllProductsResponse(.success(products))):
                    state.products = IdentifiedArray(uniqueElements: products)
                    return .none
                    
                case let .internal(.getAllProductsResponse(.failure(error))):
                    print(error.localizedDescription)
                    return .none
                    
                    //TODO: Reimplement this
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
                    
                case .delegate(.dismissedDetails):
                    state.detail = nil
                    return .none
                    
                case let .view(.selectedProduct(prod, id)):
                    guard (state.cart != nil) else {
                        print("nil cart")
                        return .none
                    }
                    state.detail = .init(
                        selectedProduct: prod,
                        cartItems: IdentifiedArrayOf(uniqueElements: state.cart!.item) ,
                        isFavourite: state.favoriteProducts.ids.contains { $0 == prod.id },
                        animationID: id
                    )
                    return .none
                    
                case .detail(.delegate(.backToBrowse)):
                    state.detail = nil
                    return .none
                    
                case let .detail(.delegate(.removedItemFromCart(id))):
                    return .run { send in
                        await send(.delegate(.removedItemFromCart(id)))
                    }
                    
                case let .detail(.delegate(.addedItemToCart(quantity: quantity, product: product))):
                    return .run {
                        send in
                        await send(.delegate(.addedItemToCart(quantity: quantity, product: product)))
                    }
                    
                case let .favorite(.loadFavoriteProducts(products)):
                    guard !products.isEmpty else {
                        return .none
                    }
                    
                    state.favoriteProducts.ids = products
                    return .none
                    
                case let .detail(.delegate(.toggleFavourite(id))):
                    return .run { send in
                        await send(.favorite(.favoriteButtonTapped(id)))
                    }
                    
                case let .favorite(.favoriteButtonTapped(id)):
                    print(state.favoriteProducts)
                    guard !state.favoriteProducts.ids.contains(id) else {
                        print("WRONG")
                        return .run { send in
                            await send(.favorite(.removeFavouriteProduct(try self.favouritesClient.removeFavorite(id)!)))
                        }
                    }
                    
                    return .run { send in
                        print("RIGHT")
                        await send(.favorite(.addFavouriteProduct(try self.favouritesClient.addFavorite(id)!)))
                    }
                    
                case let .favorite(.removeFavouriteProduct(sku)):
                    state.favoriteProducts.ids.removeAll(where: { $0 == sku })
                    return .none
                    
                case let .favorite(.addFavouriteProduct(sku)):
                    state.favoriteProducts.ids.append(sku)
                    return .none
                    
                case .view, .delegate, .internal, .favorite, .detail:
                    return .none
//                case .delegate(.removedItemFromCart(_)):
//                    <#code#>
//                case .delegate(.addedItemToCart(quantity: let quantity, product: let product)):
//                    <#code#>
                }
            }
            .ifLet(\.detail, action: /Action.detail) {
                Detail()
            }
    }
}

