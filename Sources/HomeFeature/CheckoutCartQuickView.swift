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
                    ForEach(viewStore.state.cart?.item ?? [], id: \.id) { item in
                        CartProductView(item: item, products: [])
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive, action: { viewStore.send(
                                    .cart(
                                        .removeItemFromCartTapped(item.id))) } ) {
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
            KFImage(URL(string: products.first(where: { $0.id == item.id})?.boardgame.imageURL ?? ""))
                .resizable()
                .scaledToFit()
            VStack {
                Text(products.first(where: { $0.id == item.id})?.boardgame.title ?? "")
                Text(products.first(where: { $0.id == item.id})?.boardgame.category.rawValue ?? "")
            }
            Text("\(item.quantity.rawValue * (products.first?.price.brutto ?? 1))")
        }
        .frame(height: 30)
    }
}

public extension CheckoutQuickView {
    struct ModifyQuantity: View {
        
        @State var quantity: Int = 0
        let product: Product
        let modifyQuantityAction: (Int, Product) -> Void
        
        public init(product: Product, modifyQuantityAction: @escaping (Int, Product) -> Void) {
            self.product = product
            self.modifyQuantityAction = modifyQuantityAction
        }
        
        public var body: some View {
            HStack {
                Button(action:
                        { quantity -= 1 },
                       label: {
                    Image(systemName: "minus")
                        .foregroundColor(Color("Secondary"))
                })
                if quantity < 10 {
                    Text(String("0" + "\(quantity)"))
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color("Secondary"))
                        .animation(.default, value: quantity)
                } else {
                    Text(String("\(quantity)"))
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color("Secondary"))
                }
                Button(action: { quantity += 1 },
                       label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color("Secondary"))
                })
                Button(action: { modifyQuantityAction(quantity, product) },
                       label: {
                    Text("OK")
                        .foregroundColor(Color("Secondary"))
                })
            }
        }
    }
}
