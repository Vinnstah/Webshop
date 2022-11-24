
import Foundation
import ComposableArchitecture
import SwiftUI
import SignUpFeature
import UserLocalSettingsFeature
import TermsAndConditionsFeature
import SignInFeature

public extension Onboarding {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Onboarding>
        
        public init(
            store: StoreOf<Onboarding>
        ) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            Group {
                
                IfLetStore(self.store.scope(
                    state: \.signIn,
                    action:  Action.signIn),
                           then:SignIn.View.init(store:)
                )
                
                IfLetStore(self.store.scope(
                    state: \.signUp,
                    action: Action.signUp ),
                           then: SignUp.View.init(store:)
                )
                
                IfLetStore(self.store.scope(
                    state: \.userLocalSettings,
                    action: Action.userLocalSettings),
                           then: UserLocalSettings.View.init(store:)
                )
                
                IfLetStore(self.store.scope(
                    state: \.termsAndConditions,
                    action: Action.termsAndConditions),
                           then: TermsAndConditions.View.init(store:)
                )
            }
        }
    }
}


