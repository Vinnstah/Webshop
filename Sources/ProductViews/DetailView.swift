
import Foundation
import SwiftUI
import ProductModel

public struct DetailView: SwiftUI.View {
    public let product: Product
    public let buttonAction: () -> Void
    public let increaseQuantityAction: () -> Void
    public let decreaseQuantityAction: () -> Void
    public let quantity: Int
    
    public init(
        product: Product,
        buttonAction: @escaping () -> Void,
        increaseQuantityAction: @escaping () -> Void,
        decreaseQuantityAction: @escaping () -> Void,
        quantity: Int
    ) {
        self.product = product
        self.buttonAction = buttonAction
        self.increaseQuantityAction = increaseQuantityAction
        self.decreaseQuantityAction = decreaseQuantityAction
        self.quantity = quantity
    }
    
    public var body: some SwiftUI.View {
        ScrollView(.vertical) {
            
            VStack(spacing: 20) {
                getImage(imageURL: product.imageURL)
                    .padding(.top)
                
                Text(product.title)
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                HStack(spacing: 15) {
                    Text(product.category)
                        .font(.body)
                    Text(product.subCategory)
                        .font(.footnote)
                    Text(product.sku)
                        .font(.footnote)
                }
                Text(product.description)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .frame(width: 250)
                
                Text("\(product.price) kr")
                    .font(.largeTitle)
            }
        }
        
        Button("Add to cart") {
            buttonAction()
        }
        .buttonStyle(.primary)
        
        HStack {
            Button("-") {
                decreaseQuantityAction()
            }
            Text(String("\(quantity)"))
            Button("+") {
                increaseQuantityAction()
            }
        }
    }
}
