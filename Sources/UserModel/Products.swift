import Foundation
import PostgresNIO
import SwiftUI
import ComposableArchitecture

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
                    AsyncImage(url: URL(string: product.imageURL)) { maybeImage in
                        if let image = maybeImage.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 250, height: 250)
                            
                        } else if maybeImage.error != nil {
                            Text("No image available")
                            
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
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
