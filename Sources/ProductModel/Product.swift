import Foundation
import Network
import PostgresNIO
import NIOCore
import SwiftUI
import ComposableArchitecture
import StyleGuide

extension URL: @unchecked Sendable {}

public struct Product: Equatable, Codable, Sendable, Hashable, Identifiable, Comparable {
    public static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.title < rhs.title
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(imageURL)
        hasher.combine(price)
        hasher.combine(category)
        hasher.combine(subCategory)
        hasher.combine(sku)
    }
    
    
    public let id: Int
    public let title: String
    public let description: String
    public let imageURL: String
    public let price: Int
    public let category: String
    public let subCategory: String
    public let sku: String
    
    public init(id: Int,
                title: String,
                description: String,
                imageURL: String,
                price: Int,
                category: String,
                subCategory: String,
                sku: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.price = price
        self.category = category
        self.subCategory = subCategory
        self.sku = sku
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






