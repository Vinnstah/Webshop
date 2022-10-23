import Foundation
import SwiftUI
import ComposableArchitecture
import ProductModel
import StyleGuide

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
                            Product.ProductView<Home>(store: store, product: prod)
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
//                Product.DetailView<Home>(
//                    store: store,
//                    product: viewStore.state.productDetailView!,
//                    action: .internal(.addItemToCart(viewStore.state.productDetailView!, quantity: 1)))
                DetailView(
                    product: viewStore.state.productShownInDetailView!, action: {
                    viewStore.send(.internal(.addItemToCart(viewStore.state.productShownInDetailView!, quantity: 1)))
                })
            }
        }
    }
}
}

