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
                    List {
                        ForEach(viewStore.state.cart?.products.sorted(by: >) ?? [], id:\.key.title) { key, value in
                            Section {
                                HStack {
                                    Text(String(value))
                                    Text(key.title)
                                    Text(String(key.price))
                                }
                            }
                        }
                        Text(String(viewStore.state.cart?.price ?? 0))
                    }
                }
            }
        }
    }
}

