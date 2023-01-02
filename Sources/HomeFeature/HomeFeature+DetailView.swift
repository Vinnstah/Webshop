import Foundation
import SwiftUI
import Product
import ProductViews
import ComposableArchitecture
import CartModel
import Kingfisher

public extension Home {
    struct DetailView: SwiftUI.View {
        
        public let store: StoreOf<Home>
        public let product: Product
        public let isFavourite: () -> Bool
        public let toggleFavourite: () -> Void
        public var animation: Namespace.ID
        
        public init(
            store: StoreOf<Home>,
            product: Product,
            isFavourite: @escaping () -> Bool,
            toggleFavourite: @escaping () -> Void,
            animation: Namespace.ID
        ) {
            self.store = store
            self.product = product
            self.isFavourite = isFavourite
            self.toggleFavourite = toggleFavourite
            self.animation = animation
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                VStack {
                    ScrollView(.vertical) {
                        
                        VStack {
                            
                            image(
                                url: product.boardgame.imageURL,
                                animationID: animation
                            )
                            
                            title(product.boardgame.title)
                            
                            priceAndCategory(
                                category: product.boardgame.category.rawValue,
                                price: product.price.brutto
                            )
                            
                            Divider()
                                .foregroundColor(.black)
                                .offset(y: -15)
                            
                            Text(product.boardgame.details.playInfo.descriptionText)
                                .font(.caption)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color("Secondary"))
                                .padding(.horizontal)
                        }
                    }
                    
                    HStack {
                        
                        quantityModule(
                            decreaseQuantity: { viewStore.send(.detailView(.decreaseQuantityButtonTapped), animation: .default) },
                            increaseQuantity: { viewStore.send(.detailView(.increaseQuantityButtonTapped), animation: .default) },
                            quantity: viewStore.state.quantity
                        )
                        
                        
                        Button("Add to cart") {
                            viewStore.send(.cart(.addProductToCartTapped(
                                quantity: viewStore.state.quantity,
                                product: product))
                            )
                        }
                        .buttonStyle(.primary)
                        .padding(.horizontal)
                        
                    }
                }
                .background {
                    Color("BackgroundColor")
                }
            }
        }
    }
}

