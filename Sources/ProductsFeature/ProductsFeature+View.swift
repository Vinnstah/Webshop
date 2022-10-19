import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel

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
                    VStack {
                        ScrollView(.vertical) {
                            LazyVGrid(columns: .init(repeating: .init(), count: 2)) {
                                
                                ForEach(
                                    (viewStore.state.searchResults == []) ?
                                        viewStore.state.productList :
                                            viewStore.state.searchResults,
                                        id: \.self
                                ) { prod in
                                    ProductView(store: store, product: prod)
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
                .sheet(isPresented:
                        viewStore.binding(
                            get: \.isProductDetailSheetPresented,
                            send: .internal(.toggleSheet))
                ) {
                    Product.DetailView<Products>(store: store, product: viewStore.state.productDetailView!)
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
                    product.getImage()
                    
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
