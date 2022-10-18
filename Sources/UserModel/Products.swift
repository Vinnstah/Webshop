import Foundation
import PostgresNIO

extension URL: @unchecked Sendable {}

public struct Product: Equatable, Codable, Sendable, Hashable, Identifiable {
    
    public let title: String
    public let description: String
    public let imageURL: String
    public let price: Int
    public let category: String
    public let subCategory: String
    public let sku: String
    public let id: String
    
    public init(title: String, description: String, imageURL: String, price: Int, category: String, subCategory: String, sku: String, id: String = UUID().uuidString) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.category = category
        self.subCategory = subCategory
        self.sku = sku
        self.id = id
    }
    
    public enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageURL = "image_url"
        case price
        case category
        case subCategory = "sub_category"
        case sku
        case id
    }
}

