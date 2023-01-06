import Product
import SwiftUI
import Foundation
import CartModel
import Kingfisher
import ComposableArchitecture

public struct CheckoutQuickView: View {
    
    public let store: StoreOf<Home>
    
    public init(store: StoreOf<Home>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                RoundedRectangle(cornerSize: .zero)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                List {
                    ForEach(viewStore.state.cart?.item ?? [], id: \.product) { item in
                        CartProductView(item: item, products: viewStore.state.products)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive, action: { viewStore.send(
                                    .cart(
                                        .removeItemFromCartTapped(item.product))) } ) {
                                            Label("Delete", systemImage: "trash")
                                        }
                            }
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: 200, maxHeight: 500, alignment: .topTrailing )
            .transition(.move(edge: .trailing))
            .onTapGesture {
                viewStore.send(.internal(.toggleCheckoutQuickViewTapped), animation: .default)
            }
        }
        .background {
            Color("Secondary")
        }
    }
    
}

public struct CartProductView : View {
    public var item: Cart.Item
    public var products: IdentifiedArrayOf<Product>
    
    public init(
        item: Cart.Item,
        products: IdentifiedArrayOf<Product>
    ) {
        self.item = item
        self.products = products
    }
    
    
    public var body: some View {
        HStack {
            Text("\(item.quantity.rawValue)")
            KFImage(URL(string: products.first(where: { $0.id == item.product})?.boardgame.imageURL ?? ""))
                .resizable()
                .scaledToFit()
            VStack {
                Text(products.first(where: { $0.id == item.product})?.boardgame.title ?? "")
                Text(products.first(where: { $0.id == item.product})?.boardgame.category.rawValue ?? "")
            }
            Text("\(item.quantity.rawValue * (products.first?.price.brutto ?? 1))")
        }
        .frame(height: 30)
    }
}
