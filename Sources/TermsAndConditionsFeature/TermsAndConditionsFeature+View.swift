import Foundation
import ComposableArchitecture
import SwiftUI
import StyleGuide

public extension TermsAndConditions {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<TermsAndConditions>
        
        public init(store: StoreOf<TermsAndConditions>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ForceFullScreen {
                    VStack {
                        
                        termsAndConditionsScrollView()
                        
                        Spacer()
                        
                        acceptTermsAndConditionsCheckbox(
                            toggleAction: { viewStore.state.areTermsAndConditionsAccepted },
                            tapAction: { viewStore.send(.internal(.termsAndConditionsBoxTapped)) })
                        
                        actionButton(
                            text: "Sign Up",
                            action: { viewStore.send(.internal(.finishSignUpButtonTapped)) },
                            isDisabled: { !viewStore.areTermsAndConditionsAccepted })
                        
                        secondaryActionButton(
                            text: "Previous Step", action: {
                                viewStore.send(.delegate(.previousStepTapped(delegating: viewStore.state.user)),
                                               animation: .default)
                                
                            })
                    }
                }
            }
        }
    }
}
