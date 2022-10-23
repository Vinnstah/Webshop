import Foundation
import ProductModel

public struct Cart: Equatable, Identifiable, Sendable, Hashable, Codable {
    
    public var id: String
    public var products: [Product : Int]
    public var userJWT: String?
    
    public var numberOfItemsInCart: Int {
        products.values.reduce(0, +)
        }
    
    public var price: Int {
        products.map({ $0.value * $0.key.price}).reduce(0, +)
    }
    
    public init(
        id: String = UUID().uuidString,
        products: [Product : Int],
        userJWT: String?
    ) {
        self.id = id
        self.products = products
        self.userJWT = userJWT
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public mutating func addItemToCart(product: Product, quantity: Int){
//        self = Self(products: products.updateValue(quantity, forKey: product))
        self.products[product] = quantity
//        return products
    }
}
