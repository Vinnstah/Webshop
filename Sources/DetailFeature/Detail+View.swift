import Foundation
import StyleGuide
import SwiftUI
import Product
import ProductViews
import ComposableArchitecture
import CartModel
import Kingfisher

public extension Detail {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Detail>
        
        public init(
            store: StoreOf<Detail>
        ) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                VStack {
                    backButton {
                        viewStore.send(.delegate(.backToBrowse))
                    }
                    ScrollView(.vertical) {
                        
                        VStack {
                            
                            image(
                                url: viewStore.state.selectedProduct.boardgame.imageURL,
                                animationID: viewStore.state.animationID
                            )
                            
                            title(viewStore.state.selectedProduct.boardgame.title)
                            
                            priceAndCategory(
                                category: viewStore.state.selectedProduct.boardgame.category.rawValue,
                                price: viewStore.state.selectedProduct.price.brutto
                            )
                            
                            Divider()
                                .foregroundColor(.black)
                                .offset(y: -15)
                            
                            descriptionText(viewStore.state.selectedProduct.boardgame.details.playInfo.descriptionText)
                            
                        }
                    }
                    
                    HStack {
                        
                        quantityModule(
                            decreaseQuantity: { viewStore.send(.detailView(.decreaseQuantityButtonTapped), animation: .default) },
                            increaseQuantity: { viewStore.send(.detailView(.increaseQuantityButtonTapped), animation: .default) },
                            quantity: viewStore.state.quantity
                        )
                        
                        viewStore.state.cartItems.contains(where: {$0.id == viewStore.state.selectedProduct.id }) ?
                            
                        Button("Remove from Cart") {
                            viewStore.send(.delegate(
                                .removedItemFromCart(
                                    viewStore.state.selectedProduct.id
                                )
                            )
                            )
                        }
                        .buttonStyle(.primary(alternativeColor: Color("Secondary")))
                        .padding(.horizontal)
                        :
                        Button("Add to cart") {
                            viewStore.send(.delegate(
                                .addedItemToCart(
                                    quantity: viewStore.state.quantity,
                                    product: viewStore.state.selectedProduct)
                            )
                            )
                        }
                        .buttonStyle(.primary)
                        .padding(.horizontal)
                    }
                }
                .background {
                    Color("BackgroundColor")
                }
                .task {
                    viewStore.send(.task)
                }
            }
        }
    }
}

public extension Detail.View {
    func image(
        url: String
        ,
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
public extension Detail.View {
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

public extension Detail.View {
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

public extension Detail.View {
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

public extension Detail.View {
    func descriptionText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color("Secondary"))
            .padding(.horizontal)
    }
}
public extension Detail.View {
    func backButton(action: @escaping () -> ()) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "chevron.left")
                .bold()
                .padding()
                .foregroundColor(Color("Secondary"))
        })
    }
}
