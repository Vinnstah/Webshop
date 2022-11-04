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
                RoundedRectangle(cornerSize: .zero)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                
                VStack {
                    getImage(imageURL: product.imageURL)
                        .scaledToFill()
                    //                        .frame(width: 150, height: 150)
                    HStack {
                        Text(product.title)
                            .foregroundColor(Color("Secondary"))
                            .font(.title)
//                            .lineLimit(2)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                        //                        .frame(width: 150)
                        //                        .padding()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("\(product.price)"+" kr")
                            .foregroundColor(Color("ButtonColor"))
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                            .bold()
                        
                        Spacer()
                        
                        favoriteButton(action: { action() }, isFavorite: isFavorite(), bgColor: .white)
                    }
                    .padding([.horizontal, .bottom])
                    
                }
            }
        }
    }
}


@ViewBuilder
public func getImage(imageURL: String) -> some View {
    AsyncImage(url: URL(string: imageURL)) { maybeImage in
        if let image = maybeImage.image {
            image
                .resizable()
                .padding([.horizontal, .top])
            
        } else if maybeImage.error != nil {
            Text("No image available")
            
        } else {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 400)
        }
    }
}

@ViewBuilder
public func favoriteButton(action: @escaping ()-> Void, isFavorite: Bool?, bgColor: Color) -> some View {
    if isFavorite != nil {
        Button(action: {
            action()
        }, label: {
            Image(systemName: isFavorite! ? "heart.fill" : "heart")
                .foregroundColor(Color("ButtonColor"))
                .background {
                    bgColor
                        .clipShape(Circle())
                }
        })
    }
}

