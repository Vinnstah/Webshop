import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel

public extension Home {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Home>
        
        public init(store: StoreOf<Home>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                VStack {
                    Text("Welcome back USER")
                        .padding(.horizontal, 14)
                    
                    Text("Show popular items")
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(viewStore.state.productList, id: \.self) { prod in
                                ProductView(store: store, product: prod)
                                    .onTapGesture {
                                        viewStore.send(.internal(.showProductDetailViewFor(prod)), animation: .default)
                                    }
                            }
                        }
                    }
                    
                    Button("Log out user") {
                        viewStore.send(.internal(.logOutUser))
                    }
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
                    Product.DetailView<Home>(store: store, product: viewStore.state.productDetailView!)
                }
            }
        }
    }
}

public struct ProductView: SwiftUI.View {
    public let store: StoreOf<Home>
    public let product: Product
    
    public init(
        store: StoreOf<Home>,
        product: Product
    ) {
        self.store = store
        self.product = product
    }
    
    public var body: some SwiftUI.View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 250)
                    .foregroundColor(.indigo)
                    .cornerRadius(25)
                VStack {
                    AsyncImage(url: URL(string: product.imageURL)) { maybeImage in
                        if let image = maybeImage.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                            
                        } else if maybeImage.error != nil {
                            Text("No image available")
                            
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .padding()
                    
                    Text(product.title)
                        .foregroundColor(Color.white)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: 200, height: 250)
        }
    }
}



