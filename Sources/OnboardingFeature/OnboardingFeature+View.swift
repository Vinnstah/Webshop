
import Foundation
import ComposableArchitecture
import SwiftUI
import SignUpFeature
import UserLocalSettingsFeature
import TermsAndConditionsFeature
import LoginFeature

public extension Onboarding {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Onboarding>
        
        public init(
            store: StoreOf<Onboarding>
        ) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            IfLetStore(store.scope(state: \.route, action: Onboarding.Action.route)) { routeStore in
                SwitchStore(routeStore) {
                    
                    CaseLet(state: /State.Route.login,
                            action: Action.Route.login) {
                        Login.View.init(store: $0)
                            .transition(.push(from: .leading))
                    }
                    
                    CaseLet(state: /State.Route.signUp,
                            action: Action.Route.signUp) {
                        SignUp.View.init(store: $0)
                            .transition(.push(from: .leading))
                    }
                    
                    CaseLet(state: /State.Route.userLocalSettings,
                            action: Action.Route.userLocalSettings) {
                        UserLocalSettings.View.init(store: $0)
                            .transition(.push(from: .leading))
                    }
                    
                    CaseLet(state: /State.Route.termsAndConditions,
                            action: Action.Route.termsAndConditions) {
                        TermsAndConditions.View.init(store: $0)
                            .transition(.push(from: .leading))
                    }
                }
            }
        }
    }
}

