import Foundation
import ProductModel

public struct Cart: Equatable, Identifiable, Sendable, Hashable, Codable {
    
    public var id: String
    public var products: [Product : Int]
    public var userJWT: String
    public var databaseID: String?
    
    public var numberOfItemsInCart: Int {
        products.values.reduce(0, +)
        }
    
    public var price: Int {
        products.map({ $0.value * $0.key.price}).reduce(0, +)
    }
    
    public init(
        id: String = UUID().uuidString,
        products: [Product : Int] = [:],
        userJWT: String,
        databaseID: String? = nil
    ) {
        self.id = id
        self.products = products
        self.userJWT = userJWT
        self.databaseID = databaseID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public mutating func addItemToCart(product: Product, quantity: Int){
        self.products[product] = quantity
    }
}
