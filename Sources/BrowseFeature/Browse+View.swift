import Foundation
import ProductViews
import SwiftUI
import ComposableArchitecture
import Boardgame
import Kingfisher

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
//                            list: { viewStore.state.filteredProducts == [] ? viewStore.state.products : viewStore.state.filteredProducts },
                            list: { viewStore.state.products },
                            columns: viewStore.state.columnsInGrid,
                            content: { product in
                                Button(action: {
                                    
                                    viewStore.send(.view(.selectedProduct(product)), animation: .easeIn)
                                }, label: {
                                    
                                    ProductCardView<Browse>(
                                        store: store,
                                        product: product,
                                        action:{ viewStore.send(.favorite(.favoriteButtonTapped(product))) },
                                        isFavorite: { viewStore.state.favoriteProducts.ids.contains(product.id) }
                                    )
                                    .matchedGeometryEffect(id: product.boardgame.imageURL, in: animation)
                                }
                                )
                            }
                        )
                    }
                    
                    if viewStore.state.selectedProduct != nil {
                        DetailView(
                            store: store,
                            product: viewStore.state.selectedProduct!,
                            isFavourite: { viewStore.state.favoriteProducts.ids.contains(viewStore.state.selectedProduct!.id) },
                            toggleFavourite: {viewStore.send(.favorite(.favoriteButtonTapped(viewStore.state.selectedProduct!)))},
                            animation: animation,
                            quantity: 1
                        )
                    }
                }
                .onAppear {
                    viewStore.send(.internal(.onAppear))
                }
                .task {
                    viewStore.send(.task)
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

public extension Browse.DetailView {
    func image(
        url: String,
        animationID: Namespace.ID
    ) -> some View {
        KFImage(URL(string: url))
            .resizable()
            .padding([.horizontal, .top])
            .frame(maxWidth: .infinity)
            .frame(height: 350)
            .clipShape(Rectangle())
            .cornerRadius(40)
            .ignoresSafeArea()
            .matchedGeometryEffect(id: url, in: animationID)
    }
}
public extension Browse.DetailView {
    func title(_ title: String) -> some View {
        
        HStack {
            Text(title)
                .font(.largeTitle)
                .scaledToFit()
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .frame(width: 350)
                .frame(alignment: .leading)
        }
    }
}

public extension Browse.DetailView {
    func priceAndCategory(
        category: String,
        price: Int
    ) -> some View {
        
        HStack {
            VStack {
                Text(category)
                    .font(.system(size: 10))
                    .foregroundColor(Color("Secondary"))
                    .frame(alignment:.leading)
            }
            .padding(.leading, 30)
            
            Spacer()
            
            Text("\(price) kr")
                .font(.title)
                .bold()
                .foregroundColor(Color("Primary"))
                .frame(alignment: .center)
                .padding(.trailing, 50)
        }
    }
}

public extension Browse.DetailView {
    func quantityModule(
        decreaseQuantity: @escaping () -> Void,
        increaseQuantity: @escaping () -> Void,
        quantity: Int
    ) -> some View {
        HStack {
            Button(action: { decreaseQuantity() },
                   label: {
                Image(systemName: "minus")
                    .foregroundColor(Color("Secondary"))
            })
            if quantity < 10 {
                Text(String("0" + "\(quantity)"))
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color("Secondary"))
                    .animation(.default, value: quantity)
            } else {
                Text(String("\(quantity)"))
                    .font(.title3)
                    .bold()
                    .foregroundColor(Color("Secondary"))
            }
            Button(action: { increaseQuantity() },
                   label: {
                Image(systemName: "plus")
                    .foregroundColor(Color("Secondary"))
            })
        }
        .fixedSize()
        .padding(.horizontal)
    }
}

public extension Browse.DetailView {
    func descriptionText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color("Secondary"))
            .padding(.horizontal)
    }
}
