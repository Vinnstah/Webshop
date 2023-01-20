
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
        @ObservedObject var viewStore: ViewStoreOf<Main>
        private let store: StoreOf<Main>

        public init(store: StoreOf<Main>) {
            self.store = store
            viewStore = .init(store, observe: { $0 })
        }
        
        public var body: some SwiftUI.View {
            ZStack {
                TabView(selection: viewStore.binding(\.$selectedTab) ) {
                        Home.View(
                            store: self.store.scope(state: \.home.value , action: Main.Action.home)
                            )
                        .tag(Main.State.Tab.home)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        
                        Favorites.View(
                            store: self.store.scope(state: \.favorites.value, action: Main.Action.favorites)
                        )
                        .tag(Main.State.Tab.favorites)
                        .tabItem {
                            Label("Favorites", systemImage: "heart")
                        }
                        
                        Checkout.View(
                            store: self.store.scope(state: \.checkout.value, action: Main.Action.checkout)
                        )
                        .tag(Main.State.Tab.checkout)
                        .tabItem {
                            Label("Checkout", systemImage: "cart")
                        }
                    }
                    .accentColor(Color("Primary"))
                
            }
            }
        }
    }
