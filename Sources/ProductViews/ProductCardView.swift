//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-10-24.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import ProductModel

public struct ProductCardView<T: ReducerProtocol> : SwiftUI.View where T.State: Equatable {
    public let store: StoreOf<T>
    public let product: Product
    public let action: () -> Void
    public let isFavorite: () -> Bool
    
    public init(
        store: StoreOf<T>,
        product: Product,
        action: @escaping () -> Void,
        isFavorite: @escaping () -> Bool
    ) {
        self.store = store
        self.product = product
        self.action = action
        self.isFavorite = isFavorite
    }
    
    public var body: some SwiftUI.View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    getImage(imageURL: product.imageURL)
                    
                    Text(product.title)
                        .foregroundColor(Color("Secondary"))
                        .font(.title.bold())
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding()
                    favoriteButton(action: action, isFavorite: isFavorite)
                }
            }
            .frame(width: 200, height: 250)
        }
    }
}

    
    @ViewBuilder
     func getImage(imageURL: String) -> some View {
        AsyncImage(url: URL(string: imageURL)) { maybeImage in
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
    
@ViewBuilder
func favoriteButton(action: @escaping () -> Void, isFavorite: @escaping () -> Bool) -> some View {
    Button(action: {
        action()
    }, label: {
        Image(systemName: isFavorite() ? "heart.fill" : "heart")
            .clipShape(Circle())
            .frame(width: 50, height: 50)
    })
}

