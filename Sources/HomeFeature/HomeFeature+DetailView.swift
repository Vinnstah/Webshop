import Foundation
import SwiftUI
import ProductModel
import ProductViews
import ComposableArchitecture
import CartModel

public extension Home {
    struct DetailView: SwiftUI.View {
        public let store: StoreOf<Home>
        public let product: Product
        
        public init(store: StoreOf<Home>,
                    product: Product) {
            self.store = store
            self.product = product
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                CustomNavBar(isRoot: false, isCartPopulated: { viewStore.state.cart?.session == nil }) {
                    VStack {
                        ScrollView(.vertical) {
                            
                            VStack {
                                getImage(imageURL: product.imageURL)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 350)
                                    .clipShape(Rectangle())
                                    .cornerRadius(40)
                                    .ignoresSafeArea()
                                //                                .overlay {
                                //                                    favoriteButton(action: {
                                //                                        viewStore.send(.internal(.favoriteButtonClicked(viewStore.state.product!)))
                                //                                    }, isFavorite: {
                                //                                        viewStore.state.favoriteProducts.sku.contains(viewStore.state.product!.sku)
                                //                                    })
                                //                                }
                                
                                HStack {
                                    VStack {
                                        Text(product.title)
                                            .font(.title)
                                            .bold()
                                            .frame(alignment: .leading)
                                        
                                        Text(product.category)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color("Secondary"))
                                            .frame(alignment:.leading)
                                        
                                        Text(product.subCategory)
                                            .font(.system(size: 8))
                                            .foregroundColor(Color("Secondary"))
                                            .frame(alignment: .leading)
                                    }
                                    .padding(.leading, 30)
                                    
                                    Spacer()
                                    
                                    Text("\(product.price) kr")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color("ButtonColor"))
                                        .frame(alignment: .center)
                                        .padding(.trailing, 50)
                                }
                                
                                Divider()
                                    .foregroundColor(.black)
                                    .offset(y: -15)
                                
                                Text(product.description)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color("Secondary"))
                                    .padding(.horizontal)
                            }
                        }
                        
                        HStack {
                            HStack {
                                Button(action: { viewStore.send(.internal(.decreaseQuantityButtonPressed)) }, label: { Image(systemName: "minus") })
                                
                                Text(String("\(viewStore.state.quantity)"))
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color("Secondary"))
                                
                                Button(action: { viewStore.send(.internal(.increaseQuantityButtonPressed)) }, label: { Image(systemName: "plus") })
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
                }
                .navigationBarHidden(true)
            }
        }
    }
}
