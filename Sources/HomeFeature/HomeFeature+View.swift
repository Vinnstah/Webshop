import Foundation
import SwiftUI
import ComposableArchitecture
import Product
import StyleGuide
import ProductViews
import CheckoutFeature
import CartModel
import NavigationBar
import Boardgame

public extension Home {
    struct View: SwiftUI.View {
        @Namespace var animation
        public let store: StoreOf<Home>
        private let categories: IdentifiedArrayOf<Boardgame.Category>
        
        public init(
            store: StoreOf<Home>,
            categories: IdentifiedArrayOf<Boardgame.Category> = IdentifiedArray(uniqueElements: Boardgame.Category.allCases)
        ) {
            self.store = store
            self.categories = categories
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
                                
//                                categoryFiltering(
//                                    categories: categories,
//                                    filterAction: { viewStore.send(.internal(.categoryButtonTapped(category)), animation: .default)} )
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 20) {
                                        
                                        ForEach(categories
                                        ) { category in
                                            Button(
                                                category.rawValue
                                            ) {
                                                viewStore.send(.internal(.categoryButtonTapped(category)), animation: .default)
                                            }
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .frame(height: 30)
                                            .buttonStyle(.primary(cornerRadius: 25))
                                        }
                                    }
                                }
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
                        CheckoutQuickView(
                            store: self.store)
                        : nil
                    }
                }
                )
            }
        }
    }
}
