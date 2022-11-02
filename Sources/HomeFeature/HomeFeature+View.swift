import Foundation
import SwiftUI
import ComposableArchitecture
import ProductModel
import StyleGuide
import ProductViews
import CheckoutFeature

public extension Home {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Home>
        
        public init(store: StoreOf<Home>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                NavigationBar(
                    isRoot: true,
                    isCartPopulated: { viewStore.state.cart?.session == nil },
                    isFavourite: nil
                ) {
                    VStack {
                        if viewStore.searchResults.isEmpty {
                            
                            VStack {
                                Text("Categories")
                                    .foregroundColor(Color("Secondary"))
                                    .bold()
                                    .padding()
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 20) {
                                        
                                        ForEach(viewStore.state.catergories, id: \.self) { cat in
                                            Text(cat.title)
                                                .foregroundColor(Color("Secondary"))
                                                .padding()
                                        }
                                    }
                                }
                            }
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    
                                    ForEach(
                                        (viewStore.state.searchResults == []) ?
                                        viewStore.state.productList :
                                            viewStore.state.searchResults,
                                        id: \.self
                                    )  { prod in
                                        NavigationLink(destination: {
                                            DetailView(
                                                store: store,
                                                product: prod,
                                                isFavourite: { viewStore.state.favoriteProducts.sku.contains(prod.sku)},
                                                toggleFavourite: { viewStore.send(.internal(.favoriteButtonClicked(prod)))} )
                                        }, label: {
                                            ProductCardView<Home>(store: store, product: prod, action:
                                                                    { viewStore.send(.internal(.favoriteButtonClicked(prod))) }
                                                                  , isFavorite: {
                                                viewStore.state.favoriteProducts.sku.contains(prod.sku)
                                            })
                                            
                                        })
                                    }
                                }
                            }
                        }
                        if !viewStore.searchResults.isEmpty {
                            ScrollView(.vertical) {
                                LazyVGrid(columns: .init(repeating: .init(), count: 2)) {
                                    ForEach(
                                        (viewStore.state.searchResults == []) ?
                                        viewStore.state.productList :
                                            viewStore.state.searchResults,
                                        id: \.self
                                    )  { prod in
                                        NavigationLink(destination: {
                                            DetailView(
                                                store: store,
                                                product: prod,
                                                isFavourite: { viewStore.state.favoriteProducts.sku.contains(prod.sku) },
                                                toggleFavourite: {viewStore.send(.internal(.favoriteButtonClicked(prod)))} )
                                        }, label: {
                                            ProductCardView<Home>(store: store, product: prod, action:
                                                                    { viewStore.send(.internal(.favoriteButtonClicked(prod))) }
                                                                  , isFavorite: {
                                                viewStore.state.favoriteProducts.sku.contains(prod.sku)
                                            })
                                            
                                        })
                                    }
                                }
                                
                            }
                        }
                        Button("Log out user") {
                            viewStore.send(.internal(.logOutUser))
                        }
                        .buttonStyle(.primary)
                        .padding()
                    }
                    
                }
                .onAppear {
                    viewStore.send(.internal(.onAppear))
                }
                .refreshable {
                    viewStore.send(.internal(.onAppear))
                }
                .searchable(text:  viewStore.binding(
                    get: { $0.searchText },
                    send: { .internal(.searchTextReceivesInput($0)) })
                )
                .navigationBarHidden(true)
            }
        }
    }
}

