import Foundation
import SwiftUI


extension Image: @unchecked Sendable {}

public struct Category: Equatable, Codable, Sendable, Hashable, Identifiable {
    public var title: String
    public var id: String
    public var image: String?
    public var subCategory: SubCategory
    
    public init(title: String, id: String = UUID().uuidString, image: String? = nil, subCategory: SubCategory) {
        self.title = title
        self.id = id
        self.image = image
        self.subCategory = subCategory
    }
    
    public func getImage() -> Image? {
        guard let image else {
            return nil
        }
        return Image(systemName: image)
    }
    
    
    
    public enum CodingKeys: String, CodingKey {
        case title
        case image
        case id
        case subCategory
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    
    public struct SubCategory: Equatable, Codable, Sendable, Hashable, Identifiable {
        public var title: String
        public var id: String
        public var image: String?
        
        public init(title: String, id: String = UUID().uuidString, image: String? = nil) {
            self.title = title
            self.id = id
            self.image = image
        }
        
        //TODO: Fix this to be a hardcoded image, Async image or an image stored in the DB
        public func getImage() -> Image? {
            guard let image else {
                return nil
            }
            return Image(systemName: image)
        }
        
        public enum CodingKeys: String, CodingKey {
            case title
            case image
            case id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
