import Foundation
import SwiftUI
import ComposableArchitecture
import ProductModel
import StyleGuide
import ProductViews

public extension Home {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Home>
        
        public init(store: StoreOf<Home>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                NavigationView {
                    ForceFullScreen {
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
                                            ProductCardView<Home>(store: store, product: prod, action: ({
                                                viewStore.send(.internal(.favoriteButtonClicked(prod)))
                                            }))
                                                .onTapGesture {
                                                    viewStore.send(.internal(.showProductDetailViewFor(prod)), animation: .default)
                                                }
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
                                                ProductCardView<Home>(store: store, product: prod, action: ({
                                                    viewStore.send(.internal(.favoriteButtonClicked(prod)))
                                                }))
                                                    .onTapGesture {
                                                        viewStore.send(.internal(.showProductDetailViewFor(prod)), animation: .default)
                                                    }
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
                .sheet(isPresented:
                        viewStore.binding(
                            get: \.isProductDetailSheetPresented,
                            send: .internal(.toggleSheet))
                ) {
                    
                    DetailView(
                        product: viewStore.state.product!,
                        buttonAction: {
                            viewStore.send(.delegate(.addProductToCart(quantity: viewStore.state.quantity, product: viewStore.state.product!)
                                                    ))
                        },
                        increaseQuantityAction: { viewStore.send(.internal(.increaseQuantityButtonPressed)) },
                        decreaseQuantityAction: { viewStore.send(.internal(.decreaseQuantityButtonPressed)) },
                        quantity: viewStore.state.quantity
                    )
                }
            }
        }
    }
}

