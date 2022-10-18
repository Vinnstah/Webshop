import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel

public extension Products {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Products>
        @ObservedObject var viewStore: ViewStore<ViewState, Products.Action>

          struct ViewState: Equatable {
            let productList: [Product]
            let filteredProducts: [Product]?

            init(state: Products.State) {
              self.productList = state.productList
                self.filteredProducts = state.productList.filter { $0.title.contains(state.searchText)}
            }
          }

          public init(
            store: StoreOf<Products>
          ) {
            self.store = store
            self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
          }
        public var body: some SwiftUI.View {
            WithViewStore(self.viewStore, observe: { $0 } ) { viewStore in
                NavigationView {
                    VStack {
//                        TextField("Search",
//                                  text: viewStore.binding(
//                                    get: { $0.searchText },
//                                    send: { .internal(.searchTextReceivesInput($0)) }
//                                  )
//                        )
                        //                        if viewStore.state.searchResults != nil {
                        //                            ScrollView(.vertical) {
                        //                                LazyVGrid(columns: .init(repeating: .init(), count: 2)) {
                        //
                        //                                    ForEach(viewStore.state.searchResults!, id: \.self) { prod in
                        //                                        ProductView(store: store, product: prod)
                        //                                            .padding(.horizontal)
                        //
                        //                                    }
                        //
                        //                                }
                        //                            }
                        //                        }
                        ScrollView(.vertical) {
                            LazyVGrid(columns: .init(repeating: .init(), count: 2)) {
                                
                                ForEach(viewStore, id: \.self) { prod in
                                    ProductView(store: store, product: prod)
                                        .padding(.horizontal)
                                    
                                }
                                
                            }
                        }
                        
                        Text("Product Feature goes here")
                            .searchable(text: viewStore.binding(
                                get: { $0.searchText },
                                send: { .internal(.searchTextReceivesInput($0)) }
                            ) )
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

//Will copy to it's own package
public struct ProductView: SwiftUI.View {
    public let store: StoreOf<Products>
    public let product: Product
    
    public init(
        store: StoreOf<Products>,
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
