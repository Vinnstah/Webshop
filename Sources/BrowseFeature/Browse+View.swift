import Foundation
import ProductViews
import SwiftUI
import ComposableArchitecture
import Boardgame
import Kingfisher
import DetailFeature

public extension Browse {
    struct View: SwiftUI.View {
        @Namespace var animation
        public let store: StoreOf<Browse>
        
        public init(store: StoreOf<Browse>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: {$0}) { viewStore in
                ZStack {
                    VStack {
                        VStack {
                            
                            gridColumnControl(
                                increaseColumns: { viewStore.send(.view(.increaseNumberOfColumnsTapped), animation: .default) },
                                decreaseColumns: { viewStore.send(.view(.decreaseNumberOfColumnsTapped), animation: .default) },
                                numberOfColumnsInGrid: viewStore.state.columnsInGrid
                            )
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 20) {
                                    
                                    ForEach(viewStore.state.categories
                                    ) { category in
                                        Button(
                                            category.rawValue
                                        ) {
                                            viewStore.send(.view(.categoryButtonTapped(category)), animation: .default)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(height: 30)
                                        .buttonStyle(.primary(cornerRadius: 25))
                                    }
                                }
                            }
                        }
                        
                        StaggeredGrid(
                            list: { viewStore.state.searchResults == [] ?
                                viewStore.state.products :
                                viewStore.state.searchResults },
                            columns: viewStore.state.columnsInGrid,
                            content: { product in
                                Button(action: {
                                    
                                    viewStore.send(.view(.selectedProduct(product, animation)), animation: .easeIn)
                                }, label: {
                                    
                                    ProductCardView<Browse>(
                                        store: store,
                                        product: product,
                                        action:{ viewStore.send(.favorite(.favoriteButtonTapped(product.id))) },
                                        isFavorite: { viewStore.state.favoriteProducts.ids.contains(product.id) }
                                    )
                                    .matchedGeometryEffect(id: product.boardgame.imageURL, in: animation)
                                }
                                )
                            }
                        )
                    }
                    IfLetStore(self.store.scope(
                        state: \.detail,
                        action: Browse.Action.detail),
                               then:Detail.View.init(store:)
                    )
                }
                .onAppear {
                    viewStore.send(.internal(.onAppear))
                }
                .task {
                    await viewStore.send(.task).finish()
                }
            }
        }
    }
}

public extension Browse.View {
    
    func gridColumnControl(
        increaseColumns: @escaping () -> Void,
        decreaseColumns: @escaping () -> Void,
        numberOfColumnsInGrid: Int
    ) -> some View {
        HStack {
            Spacer()
            
            Text("Columns")
                .font(.footnote)
                .foregroundColor(.gray)
                .frame(alignment: .trailing)
            
            Button(action: { decreaseColumns()  },
                   label: {
                Image(systemName: "minus")
                    .font(.footnote)
                    .foregroundColor(Color("Secondary"))
            })
            Text(String("\(numberOfColumnsInGrid)"))
                .font(.subheadline)
                .foregroundColor(Color("Secondary"))
            
            Button(action: { increaseColumns()  },
                   label: {
                Image(systemName: "plus")
                    .font(.footnote)
                    .foregroundColor(Color("Secondary"))
            })
        }
        .padding(.horizontal)
    }
}


public extension Browse.View {
    func categoryFiltering(
    categories: IdentifiedArrayOf<Boardgame.Category>,
        filterAction: @escaping () -> Void
    ) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                
                ForEach(categories
                ) { category in
                    Button(
                        category.rawValue
                    ) {
                        filterAction()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 30)
                    .buttonStyle(.primary(cornerRadius: 25))
                }
            }
        }
    }
}
