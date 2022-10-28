
import Foundation
import UserDefaultsClient
import ComposableArchitecture
import ProductModel

fileprivate let jsonDecoder = JSONDecoder()
fileprivate let jsonEncoder = JSONEncoder()

public extension FavoritesClient {
    
    static let live: Self = {
        
        @Dependency(\.userDefaultsClient) var userDefaultsClient
        
        struct ConverterHelper: Codable {
            public var data: Data?
            public var sku: [Product.SKU]
            public var decodedData: [Product.SKU]
            public var skuKey: String
            
            public init(
                data: Data? = nil,
                sku: [Product.SKU] = [],
                decodedData: [Product.SKU] = [],
                skuKey: String = "skuKey"
            ) {
                self.data = data
                self.sku = sku
                self.decodedData = decodedData
                self.skuKey = skuKey
            }
            
            mutating func decodeData() {
                self.decodedData = try! jsonDecoder.decode([Product.SKU].self, from: self.data!)
            }
            
            mutating func encodeData() {
                self.data = try! jsonEncoder.encode(self.sku)
            }
        }
        
        return Self.init(addFavorite: { sku in
            let userDefaults = UserDefaults()
            var helper = ConverterHelper()
            
            helper.data = userDefaults.object(forKey: helper.skuKey) as? Data
            helper.decodeData()
            
            helper.decodedData.append(sku)
            
            helper.encodeData()
            userDefaults.set(helper.data, forKey: helper.skuKey)
            
            return sku
        })
    }()
}
