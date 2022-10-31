import Foundation
import SwiftUI
import ComposableArchitecture
import ProductModel
import StyleGuide
import ProductViews

public extension Favorites {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Favorites>
        @ObservedObject var viewStore: ViewStore<ViewState, Favorites.Action>
        
        struct ViewState: Equatable {
            var productList: [Product]
            
            init(state: Favorites.State) {
                self.productList = state.productList
            }
        }
        
        public init(
            store: StoreOf<Favorites>
        ) {
            self.store = store
            self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                NavigationView {
                ForceFullScreen {
                        VStack {
                            ScrollView(.vertical) {
                                LazyVGrid(columns: .init(repeating: .init(), count: 2)) {
                                    
                                    ForEach(
                                        (viewStore.state.searchResults == []) ?
                                        viewStore.state.productList :
                                            viewStore.state.searchResults,
                                        id: \.self
                                    ) { prod in
                                        ProductCardView<Favorites>(store: store, product: prod, action: {
                                            viewStore.send(.internal(.favoriteButtonClicked(prod)))
                                        }, isFavorite: {
                                            viewStore.favoriteProducts.sku.contains(prod.sku)
                                        })
                                            .padding(.horizontal)
                                            .onTapGesture {
                                                viewStore.send(.internal(.showProductDetailViewFor(prod)), animation: .default)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    
                    .searchable(text:  viewStore.binding(
                        get: { $0.searchText },
                        send: { .internal(.searchTextReceivesInput($0)) })
                    )
                    .onAppear {
                        viewStore.send(.internal(.onAppear))
                    }
                    .refreshable {
                        viewStore.send(.internal(.onAppear))
                    }
                }
            }
        }
    }
}
