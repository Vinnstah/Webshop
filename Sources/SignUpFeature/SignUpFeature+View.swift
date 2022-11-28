
import Foundation
import SwiftUI
import ComposableArchitecture
import StyleGuide

public extension SignUp {
    struct View: SwiftUI.View {
        public let store: StoreOf<SignUp>
        
        public init(store: StoreOf<SignUp>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ForceFullScreen {
                    VStack {
                        Spacer()
                        
                        signUpPersonImage()
                        
                        Spacer()
                        
                        HStack {
                            emailTextField(
                                text: viewStore.binding(
                                    get: { $0.email },
                                    send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                                )
                            )
                            
                            Image(systemName: viewStore.state.emailFulfillsRequirements ? "checkmark" : "xmark")
                                .foregroundColor(viewStore.state.emailFulfillsRequirements ? .green : .red)
                        }
                        .padding(.bottom)
                        
                        HStack {
                            passwordTextField(
                                text: viewStore.binding(
                                    get: { $0.password },
                                    send: { .internal(.passwordFieldReceivingInput(text: $0)) }
                                )
                            )
                            
                            Image(systemName: viewStore.state.passwordFulfillsRequirements ? "checkmark" : "xmark")
                                .foregroundColor(viewStore.state.passwordFulfillsRequirements ? .green : .red)
                            
                        }
                        .padding(.bottom)
                        
                        VStack {
                            actionButton(
                                text: "Next Step",
                                action: { viewStore.send(.delegate(.goToNextStep(viewStore.state.user)), animation: .default) },
                                isDisabled: { viewStore.state.disableButton })
                            
                            secondaryActionButton(text: "Go Back") {
                                viewStore.send(.delegate(.goToThePreviousStep), animation: .default)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
