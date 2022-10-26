
import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel
import HomeFeature
import ProductsFeature
import CheckoutFeature

public extension Main {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Main>
        
        public init(store: StoreOf<Main>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: \.selectedTab) { viewStore in
                VStack {
                    
                    TabView(selection: viewStore.binding(send: Main.Action.internal(.tabSelected))
                    ) {
                        Home.View(
                            store: self.store.scope(state: \.home!, action: Main.Action.home)
                        )
                        .tag(Main.State.Tab.home)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        
                        Products.View(
                            store: self.store.scope(state: \.products!, action: Main.Action.products)
                        )
                        .tag(Main.State.Tab.products)
                        .tabItem {
                            Label("Products", systemImage: "puzzlepiece")
                        }
                        Checkout.View(
                            store: self.store.scope(state: \.checkout!, action: Main.Action.checkout)
                        )
                        .tag(Main.State.Tab.checkout)
                        .tabItem {
                            Label("Checkout", systemImage: "cart")
                        }
                    }
                }
                .onAppear {
                    viewStore.send(.internal(.onAppear))
                }
            }
        }
    }
}
