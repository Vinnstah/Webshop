import Foundation
import Network
import PostgresNIO
import NIOCore
import SwiftUI
import ComposableArchitecture

public enum Category: Equatable, Codable, Sendable, Hashable, Identifiable {
//    public init<JSONDecoder>(from byteBuffer: inout NIOCore.ByteBuffer, type: PostgresNIO.PostgresDataType, format: PostgresNIO.PostgresFormat, context: PostgresNIO.PostgresDecodingContext<JSONDecoder>) throws where JSONDecoder : PostgresNIO.PostgresJSONDecoder {
//        self.rawValue = String(bitPat)
//            }
//        switch (format, type) {
//                case (_, .varchar),
//                     (_, .text),
//                     (_, .name):
//                    // we can force unwrap here, since this method only fails if there are not enough
//                    // bytes available.
//            self = Category(from: JbyteBuffer.readString(length: byteBuffer.readableBytes)!)
//                case (_, .uuid):
//                    guard let uuid = try? UUID(from: &byteBuffer, type: .uuid, format: format, context: context) else {
//                        throw PostgresDecodingError.Code.failure
//                    }
//                    self = uuid.uuidString
//                default:
//                    throw PostgresDecodingError.Code.typeMismatch
//                }
//    }
    
    case games(SubCategory)
    
    
    public enum CodingKeys: String, CodingKey {
        case games = "Games"
    }
    
    public var rawValue: String {
        switch self {
        case .games: return "Games"
        }
    }
    
    public var image: Image {
        switch self {
        case .games: return Image(systemName: "gamecontroller")
        }
    }
    public var id: String {
        switch self {
        case .games: return UUID().uuidString
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public enum SubCategory: Equatable, Codable, Sendable, Hashable, Identifiable {
        case boardgames
        
        public enum CodingKeys: String, CodingKey {
            case boardgames = "Board Games"
        }
        
        public var rawValue: String {
            switch self {
            case .boardgames: return "Board Games"
            }
        }
        
        public var image: Image {
            switch self {
            case .boardgames: return Image(systemName: "circle.grid.cross")
            }
        }
        
        public var id: String {
            switch self {
            case .boardgames: return UUID().uuidString
            }
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
}

extension URL: @unchecked Sendable {}

//TODO: Break out into it's own package
public struct Product: Equatable, Codable, Sendable, Hashable, Identifiable {
    
    public let title: String
    public let description: String
    public let imageURL: String
    public let price: Int
    public let category: String
    public let subCategory: String
    public let sku: String
    public let id: String
    
    public init(title: String,
                description: String,
                imageURL: String,
                price: Int,
                category: String,
                subCategory: String,
                sku: String,
                id: String = UUID().uuidString
    ) {
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
    
    @ViewBuilder
    public func getImage() -> some View {
        AsyncImage(url: URL(string: self.imageURL)) { maybeImage in
            if let image = maybeImage.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                
            } else if maybeImage.error != nil {
                Text("No image available")
                
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

public extension Product {
    struct DetailView<T: ReducerProtocol> : SwiftUI.View where T.State: Equatable {
        public let store: StoreOf<T>
        public let product: Product
        
        public init(
            store: StoreOf<T>,
            product: Product
        ) {
            self.store = store
            self.product = product
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ScrollView(.vertical) {
                    
                    VStack(spacing: 20) {
                        product.getImage()
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
            }
        }
    }
}

extension Product {
    public struct ProductView<T: ReducerProtocol> : SwiftUI.View where T.State: Equatable {
        public let store: StoreOf<T>
        public let product: Product
        
        public init(
            store: StoreOf<T>,
            product: Product
        ) {
            self.store = store
            self.product = product
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ZStack {
                    VStack {
                        product.getImage()
                        
                        Text(product.title)
                            .foregroundColor(Color("Secondary"))
                            .font(.title.bold())
                            .scaledToFill()
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .padding()
                    }
                }
                .frame(width: 200, height: 250)
            }
        }
    }
    
}
