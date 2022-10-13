
import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel

public extension Main {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Main>
        
        public init(store: StoreOf<Main>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewStore.state.productList, id: \.self) { prod in
                                ProductView(store: store, product: prod)
                                    .frame(maxWidth: 150, maxHeight: 200)
                            }
                        }
                    }
                    Text("Main Feature goes here")
                    
                    
                    HStack {
                        Text("JWT TOKEN: ")
                        Text(viewStore.state.jwt)
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
            }
        }
    }
}

public struct ProductView: SwiftUI.View {
    public let store: StoreOf<Main>
    let product: Product
    
    public init(store: StoreOf<Main>, product: Product) {
        self.store = store
        self.product = product
    }
    
    public var body: some SwiftUI.View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 250)
                    .background(Color(.blue))
                VStack {
                    AsyncImage(url: URL(string: product.imageURL))
                        .frame(width: 50, height: 50)
                    Text(product.title)
                        .foregroundColor(Color.black)
                    Text(product.description)
                        .foregroundColor(Color.teal)
                }
            }
        }
    }
    
    
}
