
import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel
import HomeFeature
import FavoriteFeature
import CheckoutFeature
import NavigationBar

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
                        VStack {
                            NavigationBar(store: self.store) {
                                Home.View(
                                    store: self.store.scope(state: \.home!, action: Main.Action.home)
                                )
                            }
                        }
                        .tag(Main.State.Tab.home)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        
                        VStack {
                            NavigationBar(store: self.store) {
                                Favorites.View(
                                    store: self.store.scope(state: \.favorites!, action: Main.Action.favorites)
                                )
                            }
                        }
                        .tag(Main.State.Tab.favorites)
                        .tabItem {
                            Label("Favorites", systemImage: "heart")
                        }
                        
                        VStack {
                            NavigationBar(store: self.store) {
                                Checkout.View(
                                    store: self.store.scope(state: \.checkout!, action: Main.Action.checkout)
                                )
                            }
                        }
                        .tag(Main.State.Tab.checkout)
                        .tabItem {
                            Label("Checkout", systemImage: "cart")
                        }
                    }
                    .accentColor(Color("Primary"))
                }
                .onAppear {
                    viewStore.send(.internal(.onAppear), animation: .default)
                }
            }
        }
    }
}

