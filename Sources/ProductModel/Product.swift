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
        public let action: T.Action
        
        public init(
            store: StoreOf<T>,
            product: Product,
            action: T.Action
        ) {
            self.store = store
            self.product = product
            self.action = action
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
                
                Button("Add to cart") {
                    viewStore.send(action)
                }
                .buttonStyle(.primary)
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

public struct DetailView: SwiftUI.View {
    public let product: Product
    public let action: () -> Void
    
    public init(product: Product, action: @escaping () -> Void) {
        self.product = product
        self.action = action
    }
    public var body: some SwiftUI.View {
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
        
        Button("Add to cart") {
            action()
        }
        .buttonStyle(.primary)
    }
}


