import Foundation
import SwiftUI
import ComposableArchitecture
import ProductModel
import StyleGuide
import ProductViews
import CheckoutFeature
import NavigationBar

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
                    isFavourite: nil,
                    toggleSettings: { viewStore.send(.internal(.toggleSettingsSheet)) },
                    searchableBinding: viewStore.binding(
                                            get: { $0.searchText },
                                            send: { .internal(.searchTextReceivesInput($0)) }).animation(),
                    cancelSearch: { viewStore.send(.internal(.cancelSearchClicked)) }
                ) {
                    VStack {
                        
                        VStack {
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    
                                    ForEach(viewStore.state.catergories, id: \.self) { category in
                                        Button(
                                            category.title
                                        ) {
                                            viewStore.send(.internal(.categoryButtonPressed(category)), animation: .default)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(height: 30)
                                        .buttonStyle(.primary(cornerRadius: 25))
                                    }
                                }
                            }
                        }
                        if viewStore.filteredProducts.isEmpty {
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    
                                    ForEach(
                                        (viewStore.state.filteredProducts == []) ?
                                        viewStore.state.productList :
                                            viewStore.state.filteredProducts,
                                        id: \.self
                                    )  { prod in
                                        NavigationLink(destination: {
                                            DetailView(
                                                store: store,
                                                product: prod,
                                                isFavourite: { viewStore.state.favoriteProducts.sku.contains(prod.sku)},
                                                toggleFavourite: { viewStore.send(.internal(.favoriteButtonClicked(prod)))} )
                                        }, label: {
                                            ProductCardView<Home>(
                                                store: store,
                                                product: prod,
                                                action: { viewStore.send(.internal(.favoriteButtonClicked(prod))) },
                                                isFavorite: { viewStore.state.favoriteProducts.sku.contains(prod.sku) })
                                        })
                                    }
                                }
                            }
                        }
                        if !viewStore.filteredProducts.isEmpty {
                            ScrollView(.vertical) {
                                LazyVGrid(columns: .init(repeating: .init(), count: 2) ) {
                                    ForEach(
                                        (viewStore.state.filteredProducts == []) ?
                                        viewStore.state.productList :
                                            viewStore.state.filteredProducts,
                                        id: \.self
                                    )  { prod in
                                        NavigationLink(destination: {
                                            DetailView(
                                                store: store,
                                                product: prod,
                                                isFavourite: { viewStore.state.favoriteProducts.sku.contains(prod.sku) },
                                                toggleFavourite: {viewStore.send(.internal(.favoriteButtonClicked(prod)))} )
                                        }, label: {
                                            ProductCardView<Home>(
                                                store: store,
                                                product: prod,
                                                action:{ viewStore.send(.internal(.favoriteButtonClicked(prod))) },
                                                isFavorite: { viewStore.state.favoriteProducts.sku.contains(prod.sku) })
                                        })
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                .onAppear {
                    viewStore.send(.internal(.onAppear))
                }
                .refreshable {
                    viewStore.send(.internal(.onAppear))
                }
                .navigationBarHidden(true)
                .sheet(isPresented:
                        viewStore.binding(
                            get: \.isSettingsSheetPresented,
                            send: .internal(.toggleSettingsSheet))
                ) {
                    Settings() {
                        viewStore.send(.internal(.logOutUser))
                    }
                    .presentationDetents([.fraction(0.1)])
                }
            }
        }
    }
}

//Temporary struct for logout button. Will create entire feature later on.
struct Settings: View {
    public let action: () -> Void
    
    public init(action: @escaping () -> Void) { self.action = action}
    
    public var body: some View {
        Button("Log out user") {
            action()
        }
        .buttonStyle(.primary)
        .padding()
    }
}
