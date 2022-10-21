import Foundation
import ProductModel

//TODO: Rename to Cart?
public struct CheckoutModel: Equatable, Identifiable, Sendable {
    
    public var id: String
    public var products: [Int : Product]
    
    public var numberOfItemsInCart: Int {
        var numberOfItems: Int = 0
        for product in products {
            numberOfItems += product.key
        }
        return numberOfItems
    }
    
    public var price: Int {
        var totalPrice: Int = 0
        for product in products {
            totalPrice += product.key * product.value.price
        }
        return totalPrice
    }
    
    public init(
        id: String = UUID().uuidString,
        products: [Int : Product]
    ) {
        self.id = id
        self.products = products
    }
}
