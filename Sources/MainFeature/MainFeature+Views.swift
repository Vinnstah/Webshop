
import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel
import HomeFeature

public extension Main {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Main>
        
        public init(store: StoreOf<Main>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: \.selectedTab) { viewStore in
                TabView(selection: viewStore.binding(send: Main.Action.internal(.tabSelected))
                                                ) {
                                                    Home.View(
                                                        store: self.store.scope(state: \.home, action: Main.Action.home)
                                                    )
                                                    .tag(Main.State.Tab.home)
                                                }
            }
        }
    }
}
