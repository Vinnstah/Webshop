import Foundation
import SwiftUI
import ComposableArchitecture
import ProductModel
import StyleGuide

public extension Products {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Products>
        @ObservedObject var viewStore: ViewStore<ViewState, Products.Action>
        
        struct ViewState: Equatable {
            var productList: [Product]
            
            init(state: Products.State) {
                self.productList = state.productList
            }
        }
        
        public init(
            store: StoreOf<Products>
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
                                        Product.ProductView<Products>(store: store, product: prod)
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
                    .sheet(isPresented:
                            viewStore.binding(
                                get: \.isProductDetailSheetPresented,
                                send: .internal(.toggleSheet))
                    ) {
                        Product.DetailView<Products>(
                            store: store,
                            product: viewStore.state.productDetailView!,
                            action: .delegate(.addProductToCart(quantity: 1, product: viewStore.state.productDetailView!)
                                             )
                        )
                    }
                }
            }
        }
    }
}
