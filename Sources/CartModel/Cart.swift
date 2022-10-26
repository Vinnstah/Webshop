import Foundation
import ProductModel

public struct Cart: Equatable, Identifiable, Sendable, Hashable, Codable {
    
    public var id: String
    public var products: [Product : Int]
    public var userJWT: String
    public var databaseID: String?
    public var session: Cart.Session?
    
    public var numberOfItemsInCart: Int {
        products.values.reduce(0, +)
        }
    
    public var price: Int {
        products.map({ $0.value * $0.key.price}).reduce(0, +)
    }
    
    public init(
        id: String,
        products: [Product : Int] = [:],
        userJWT: String,
        databaseID: String? = nil,
        session: Cart.Session? = nil
    ) {
        self.id = id
        self.products = products
        self.userJWT = userJWT
        self.databaseID = databaseID
        self.session = session  
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public mutating func addItemToCart(product: Product, quantity: Int){
        self.products[product] = quantity
    }
    
    public struct Session: Equatable, Identifiable, Sendable, Hashable, Codable {
        public var id: String
        public var jwt: String
        public var dbID: Int
        
        public init(id: String, jwt: String, dbID: Int) {
            self.id = id
            self.jwt = jwt
            self.dbID = dbID
        }
    }
}
