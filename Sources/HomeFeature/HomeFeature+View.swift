import Foundation
import SwiftUI
import ComposableArchitecture
import Product
import StyleGuide
import ProductViews
import CheckoutFeature
import CartModel
import NavigationBar

public extension Home {
    struct View: SwiftUI.View {
        @Namespace var animation
        public let store: StoreOf<Home>
        
        public init(store: StoreOf<Home>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                NavigationBar.home(viewStore: viewStore) {
                    ZStack {
                        VStack {
                            VStack {
                                
                                gridColumnControl(
                                    increaseColumns: { viewStore.send(.view(.increaseNumberOfColumnsTapped), animation: .default) },
                                    decreaseColumns: { viewStore.send(.view(.decreaseNumberOfColumnsTapped), animation: .default) },
                                    numberOfColumnsInGrid: viewStore.state.columnsInGrid
                                )
                                //TODO: Add category filtering
                                //                                ScrollView(.horizontal) {
                                //                                    HStack(spacing: 20) {
                                //
                                //                                        ForEach(viewStore.state.catergories.allCases, id: \.self) { category in
                                //                                            Button(
                                //                                                category.title
                                //                                            ) {
                                //                                                viewStore.send(.internal(.categoryButtonPressed(category)), animation: .default)
                                //                                            }
                                //                                            .frame(minWidth: 0, maxWidth: .infinity)
                                //                                            .frame(height: 30)
                                //                                            .buttonStyle(.primary(cornerRadius: 25))
                                //                                        }
                                //                                    }
                                //                                }
                            }
                            StaggeredGrid(
                                list: { viewStore.state.filteredProducts == [] ? viewStore.state.products : viewStore.state.filteredProducts },
                                columns: viewStore.state.columnsInGrid,
                                content: { product in
                                    Button(action: {
                                        viewStore.send(.detailView(.toggleDetailView(product)), animation: .easeIn)
                                    }, label: {
                                        
                                        ProductCardView<Home>(
                                            store: store,
                                            product: product,
                                            action:{ viewStore.send(.favorite(.favoriteButtonTapped(product))) },
                                            isFavorite: { viewStore.state.favoriteProducts.sku.contains(product.id) }
                                        )
                                        .matchedGeometryEffect(id: product.boardgame.imageURL, in: animation)
                                    }
                                    )
                                }
                            )
                        }
                        
                        if viewStore.state.showDetailView && viewStore.state.product != nil {
                            DetailView(
                                store: store,
                                product: viewStore.state.product!,
                                isFavourite: { viewStore.state.favoriteProducts.sku.contains(viewStore.state.product!.id) },
                                toggleFavourite: {viewStore.send(.favorite(.favoriteButtonTapped(viewStore.state.product!)))},
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
                    .sheet(isPresented:
                            viewStore.binding(
                                get: \.isSettingsSheetPresented,
                                send: .internal(.settingsButtonTapped))
                    ) {
                        Settings() {
                            viewStore.send(.internal(.signOutTapped))
                        }
                        .presentationDetents([.fraction(0.1)])
                    }
                }
                .overlay(alignment: .top, content: {
                    HStack {
                        Spacer()
                    viewStore.state.showCheckoutQuickView ?
                    //                ) {
                        CheckoutQuickView(
                            cart: (viewStore.state.cart) ?? .init(session: .init(id: .init(rawValue: .init()),
                                                                                 jwt: .init(rawValue: "TEST")),
                                                                  item: [.init(product: .init(rawValue: .init()), quantity: 2)]), tapAction: { viewStore.send(.internal(.toggleCheckoutQuickViewTapped), animation: .default) }
                        ) : nil
                    }
                }
                )
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
    
    public var cart: Cart
    public var products: [Product]
    public var tapAction: () -> Void
    
    public init(
        cart: Cart,
        products: [Product] = [],
        tapAction: @escaping () -> Void
    ) {
        self.cart = cart
        self.products = products
        self.tapAction = tapAction
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: .zero)
                .foregroundColor(.white)
                .cornerRadius(25)
            //
            VStack {
                ForEach(cart.item, id: \.product) { product in
                    Text("\(product.product.rawValue)")
                    Text(products.filter { $0.id == product.product}.description)
                    Text("\(product.quantity.rawValue)")
                }
            }
        }
        .frame(maxWidth: 200, maxHeight: 500, alignment: .topTrailing )
        .transition(.move(edge: .trailing))
        .onTapGesture {
            tapAction()
        }
    }
        
}
