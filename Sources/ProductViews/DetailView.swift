//
//import Foundation
//import SwiftUI
//import ProductModel
//
//public struct DetailView: SwiftUI.View {
//    public let product: Product
//    public let buttonAction: () -> Void
//    public let increaseQuantityAction: () -> Void
//    public let decreaseQuantityAction: () -> Void
//    public let quantity: Int
//    
//    public init(
//        product: Product,
//        buttonAction: @escaping () -> Void,
//        increaseQuantityAction: @escaping () -> Void,
//        decreaseQuantityAction: @escaping () -> Void,
//        quantity: Int
//    ) {
//        self.product = product
//        self.buttonAction = buttonAction
//        self.increaseQuantityAction = increaseQuantityAction
//        self.decreaseQuantityAction = decreaseQuantityAction
//        self.quantity = quantity
//    }
//    
//    public var body: some SwiftUI.View {
//        ScrollView(.vertical) {
//            
//            VStack {
//                getImage(imageURL: product.imageURL)
//                    .clipShape(Rectangle())
//                    .cornerRadius(40)
//                    .ignoresSafeArea()
//                    .offset(y: -25)
//                
//                HStack {
//                    VStack {
//                        Text(product.title)
//                            .font(.title)
//                            .bold()
//                            .frame(alignment: .leading)
//                        
//                        Text(product.category)
//                            .font(.system(size: 10))
//                            .foregroundColor(Color("Secondary"))
//                            .frame(alignment:.leadingFirstTextBaseline)
//                            
//                        Text(product.subCategory)
//                            .font(.system(size: 8))
//                            .foregroundColor(Color("Secondary"))
//                            .frame(alignment: .leading)
//                    }
//                    .padding(.leading, 30)
//                    
//                    Spacer()
//                    
//                    Text("\(product.price) kr")
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(Color("ButtonColor"))
//                        .frame(alignment: .center)
//                        .padding(.trailing, 50)
//                }
//                .offset(y: -25)
//                
//                Divider()
//                    .foregroundColor(.black)
//                    .offset(y: -15)
//                
//                Text(product.description)
//                    .font(.caption)
//                    .multilineTextAlignment(.leading)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .foregroundColor(Color("Secondary"))
//                    .padding(.horizontal)
//            }
//        }
//        
//        HStack {
//            HStack {
//                Button(action: { decreaseQuantityAction() }, label: { Image(systemName: "minus") })
//                
//                Text(String("\(quantity)"))
//                    .font(.title3)
//                    .bold()
//                    .foregroundColor(Color("Secondary"))
//                
//                Button(action: { increaseQuantityAction() }, label: { Image(systemName: "plus") })
//            }
//            .fixedSize()
//            .padding(.horizontal)
//            
//            Button("Add to cart") {
//                buttonAction()
//            }
//            .buttonStyle(.primary)
//            .padding(.horizontal)
//            
//        }
//    }
//}
//
