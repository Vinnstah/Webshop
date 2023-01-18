import Foundation
import SwiftUI
import ComposableArchitecture
import Product
import StyleGuide
import ProductViews
import CheckoutFeature
import CartModel
import NavigationBar
import Boardgame
import BrowseFeature

public extension Home {
    struct View: SwiftUI.View {
        @Namespace var animation
        public let store: StoreOf<Home>
        
        public init(
            store: StoreOf<Home>
        ) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
//                NavigationBar.home(viewStore: viewStore) {
                Browse.View(store: self.store.scope(state: \.browse, action: Home.Action.browse))
                    .onAppear {
                        viewStore.send(.internal(.onAppear))
                    }
                    .refreshable {
                        viewStore.send(.internal(.onAppear))
                    }
                    .sheet(isPresented:
                            viewStore.binding(
                                get: \.isSettingsSheetPresented,
                                send: .internal(.settingsButtonTapped))
                    ) {
                        Settings() {
                            viewStore.send(.internal(.signOutTapped))
                        }
                        .presentationDetents([.fraction(0.1)])
//                    }
                }
                .overlay(alignment: .top, content: {
                    HStack {
                        Spacer()
                        
                        viewStore.state.showCheckoutQuickView ?
                        CheckoutQuickView(
                            store: self.store)
                        : nil
                    }
                }
                )
            }
        }
    }
}
