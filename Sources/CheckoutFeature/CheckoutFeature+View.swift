import Foundation
import SwiftUI
import ComposableArchitecture
import Kingfisher
import Product

public extension Checkout {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Checkout>
        
        public init(store: StoreOf<Checkout>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                VStack {
                    //TODO: Will be fixed in a later PR
                    List {
                        Section(String("Quantity - Title - Price"), content: {
                            ForEach(viewStore.state.items) { item in
                                
                                HStack {
                                            Text("\(item.quantity.rawValue)")
                                    KFImage(URL(string: viewStore.state.products.first(where: { $0.id == item.id})?.boardgame.imageURL ?? ""))
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .scaledToFit()
                                                
                                            VStack {
                                                Text(viewStore.state.products.first(where: { $0.id == item.id})?.boardgame.title ?? "")
                                                Text(viewStore.state.products.first(where: { $0.id == item.id})?.boardgame.category.rawValue ?? "")
                                            }
                                    Text("\(item.quantity.rawValue * (viewStore.state.products.first?.price.brutto ?? 1))")
                                        }
//                                Text(viewStore.state.products.first(where: { $0.id == item.id}))
                            }
//                        ForEach(viewStore.state.cart?.products.sorted(by: >) ?? [], id:\.key.title) { key, value in
//                                HStack {
//                                    Text(String(value))
//                                    Text(key.title)
//                                        Text(String(key.price))
//                                        Text("kr")
//                                }
//                            }
                        }
                        )
//                        Section(String("Total"), content: {
//                            HStack {
//                                Text(String(viewStore.state.cart?.price ?? 0))
//                                Text("kr")
//                            }
//                        })
                        }
                    }
                .onAppear {
                    viewStore.send(.internal(.onAppear))
                }
                }
            }
        }
    }

