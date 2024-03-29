import Foundation
import SwiftUI
import ComposableArchitecture
import Product
import Kingfisher

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
                    KFImage(URL(string: product.boardgame.imageURL))
                        .resizable()
                        .padding([.horizontal, .top])
                        .scaledToFill()
                    HStack {
                        Text(product.boardgame.title)
                            .foregroundColor(Color("Secondary"))
                            .font(.title)
                            .scaledToFit()
                            .minimumScaleFactor(0.01)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("\(product.price.brutto)"+" kr")
                            .foregroundColor(Color("Primary"))
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
public func favoriteButton(action: @escaping ()-> Void, isFavorite: Bool?, bgColor: Color) -> some View {
    if isFavorite != nil {
        Button(action: {
            action()
        }, label: {
            Image(systemName: isFavorite! ? "heart.fill" : "heart")
                .foregroundColor(Color("Primary"))
                .background {
                    bgColor
                        .clipShape(Circle())
                }
        })
    }
}

