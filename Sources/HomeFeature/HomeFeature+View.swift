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
                VStack {
                    
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
                    
                    Text("Show popular items")
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(viewStore.state.productList, id: \.self) { prod in
                                ProductCardView<Home>(store: store, product: prod)
                                    .onTapGesture {
                                        viewStore.send(.internal(.showProductDetailViewFor(prod)), animation: .default)
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

