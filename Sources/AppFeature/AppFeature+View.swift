import Foundation
import SwiftUI
import ComposableArchitecture
import SplashFeature
import MainFeature
import OnboardingFeature

public extension App {
    struct View: SwiftUI.View {
        let store: StoreOf<App>
        
        public init(store: StoreOf<App>) {
            self.store = store
        }
        ///Scoping the correct store depending on the state
        public var body: some SwiftUI.View {
            IfLetStore(self.store.scope(
                state: /App.State.splash,
                action: App.Action.splash),
                       then:Splash.View.init(store:)
            )
            IfLetStore(self.store.scope(
                state: /App.State.onboarding,
                action: App.Action.onboarding),
                       then:Onboarding.View.init(store:)
            )
            IfLetStore(self.store.scope(
                state: /App.State.main,
                action: App.Action.main),
                       then:Main.View.init(store:)
            )
            
        }
    }
}

