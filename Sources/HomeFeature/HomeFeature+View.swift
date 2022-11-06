import Foundation
import SwiftUI
import ComposableArchitecture
import Product
import StyleGuide
import ProductViews
import CheckoutFeature
import NavigationBar
import CartModel

public extension Home {
    struct View: SwiftUI.View {
        
        @Namespace var animation
        public let store: StoreOf<Home>
        
        public init(store: StoreOf<Home>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                NavigationBar(
                    isRoot: !viewStore.state.showDetailView,
                    isCartPopulated: { viewStore.state.cart?.session == nil },
                    showCartQuickView: { viewStore.send(.internal(.toggleCheckoutQuickView), animation: .default)},
                    isFavourite: {
                        guard (viewStore.state.product != nil) else {
                            return nil
                        }
                        return viewStore.state.favoriteProducts.sku.contains(viewStore.state.product!.sku) },
                    showFavouriteSymbol: {
                        guard (viewStore.state.product != nil) else {
                            return
                        }
                        viewStore.send(.internal(.favoriteButtonClicked((viewStore.state.product!)))) },
                    showSettingsSymbol: { viewStore.send(.internal(.toggleSettingsSheet)) },
                    searchableBinding: viewStore.binding(
                        get: { $0.searchText },
                        send: { .internal(.searchTextReceivesInput($0)) }).animation(),
                    cancelSearch: { viewStore.send(.internal(.cancelSearchClicked)) },
                    previousScreenAction: { viewStore.send(.internal(.toggleDetailView(nil)), animation: .easeOut) }
                ) {
                    ZStack {
                        VStack {
                            VStack {
                                
                                HStack {
                                    Spacer()
                                    
                                    Text("Columns")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .frame(alignment: .trailing)
                                    
                                    Button(action: { viewStore.send(.internal(.decreaseNumberOfColumns), animation: .default)  },
                                           label: {
                                        Image(systemName: "minus")
                                            .font(.footnote)
                                            .foregroundColor(Color("Secondary"))
                                    })
                                    Text(String("\(viewStore.state.columnsInGrid)"))
                                        .font(.subheadline)
                                        .foregroundColor(Color("Secondary"))
                                    
                                    Button(action: { viewStore.send(.internal(.increaseNumberOfColumns), animation: .default) },
                                           label: {
                                        Image(systemName: "plus")
                                            .font(.footnote)
                                            .foregroundColor(Color("Secondary"))
                                    })
                                }
                                .padding(.horizontal
                                )
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
                            StaggeredGrid(
                                list: (viewStore.state.filteredProducts == []) ? viewStore.state.productList : viewStore.state.filteredProducts,
                                columns: viewStore.state.columnsInGrid,
                                content: { prod in
                                    Button(action: {
                                        viewStore.send(.internal(.toggleDetailView(prod)), animation: .easeIn)
                                    }, label: {
                                        ProductCardView<Home>(
                                            store: store,
                                            product: prod,
                                            action:{ viewStore.send(.internal(.favoriteButtonClicked(prod))) },
                                            isFavorite: { viewStore.state.favoriteProducts.sku.contains(prod.sku) }
                                        )
                                        .matchedGeometryEffect(id: prod.imageURL, in: animation)
                                    })
                                    
                                })
                            
                            
                        }
                        if viewStore.state.showDetailView && viewStore.state.product != nil {
                            DetailView(
                                store: store,
                                product: viewStore.state.product!,
                                isFavourite: { viewStore.state.favoriteProducts.sku.contains(viewStore.state.product!.sku) },
                                toggleFavourite: {viewStore.send(.internal(.favoriteButtonClicked(viewStore.state.product!)))},
                                animation: animation
                            )
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
                    .sheet(isPresented: viewStore.binding(
                        get: \.showCheckoutQuickView,
                        send: .internal(.toggleCheckoutQuickView))) {
                            CheckoutQuickView(cart: viewStore.state.cart ?? .init(id: "TEST", userJWT: "TEST"))
                        }
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

public struct CheckoutQuickView: View {
    
    public let cart: Cart
    public var products: [Product]
    
    public init(cart: Cart) {
        self.cart = cart
        self.products = cart.products.keys.sorted()
    }
    
    public var body: some View {
//        ZStack {
//            RoundedRectangle(cornerSize: .zero)
//                .foregroundColor(.white)
//                .cornerRadius(25)
//
            VStack {
                ForEach(products, id: \.self) { product in
                    Text("\(product.quantity!)")
                    Text(product.title)
                    Text("\(product.price)")
                }
            }
//        }
    }
}
