import Foundation
import SwiftUI
import Product
import ProductViews
import ComposableArchitecture
import CartModel
import NavigationBar
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
                                KFImage(URL(string: product.boardgame.imageURL))
                                    .resizable()
                                    .padding([.horizontal, .top])
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 350)
                                    .clipShape(Rectangle())
                                    .cornerRadius(40)
                                    .ignoresSafeArea()
                                    .matchedGeometryEffect(id: product.boardgame.imageURL, in: animation)
                                HStack {
                                    Text(product.boardgame.title)
                                        .font(.largeTitle)
                                        .scaledToFit()
                                        .minimumScaleFactor(0.01)
                                        .lineLimit(1)
                                        .frame(width: 350)
                                        .frame(alignment: .leading)
                                }
                                HStack {
                                    VStack {
                                        Text(product.boardgame.category.rawValue)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color("Secondary"))
                                            .frame(alignment:.leading)
                                    }
                                    .padding(.leading, 30)
                                    
                                    Spacer()
                                    
                                    Text("\(product.price.brutto) kr")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color("ButtonColor"))
                                        .frame(alignment: .center)
                                        .padding(.trailing, 50)
                                }
                                
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
                            HStack {
                                Button(action: { viewStore.send(.internal(.decreaseQuantityButtonPressed)) },
                                       label: {
                                    Image(systemName: "minus")
                                        .foregroundColor(Color("Secondary"))
                                })
                                if viewStore.state.quantity < 10 {
                                    Text(String("0" + "\(viewStore.state.quantity)"))
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color("Secondary"))
                                } else {
                                    Text(String("\(viewStore.state.quantity)"))
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color("Secondary"))
                                }
                                Button(action: { viewStore.send(.internal(.increaseQuantityButtonPressed)) },
                                       label: {
                                    Image(systemName: "plus")
                                        .foregroundColor(Color("Secondary"))
                                })
                            }
                            .fixedSize()
                            .padding(.horizontal)
                            
                            Button("Add to cart") {
                                viewStore.send(.delegate(.addProductToCart(quantity: viewStore.state.quantity, product: viewStore.state.product!)))
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
