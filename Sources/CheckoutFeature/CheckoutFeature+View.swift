import Foundation
import SwiftUI
import ComposableArchitecture

public extension Checkout {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Checkout>
        
        public init(store: StoreOf<Checkout>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                VStack {
                    Text("Checkout")
                        .font(.headline)
                        .bold()
                    List {
                        Section {
                            ForEach(viewStore.state.checkout?.products ?? [], id:\.self) { product in
                                HStack {
                                    Text(product.title)
                                    Text(String(product.quantity ?? 0))
                                    Text(String(product.price))
                                }
                            }
                        }
                        Section {
                            Text(String(viewStore.state.checkout?.price ?? 0))
                        }
                    }
                }
            }
        }
    }
}
