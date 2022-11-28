import Foundation
import ComposableArchitecture
import SwiftUI
import StyleGuide

public extension SignIn {
    struct View: SwiftUI.View {
        public let store: StoreOf<SignIn>
        
        public init(store: StoreOf<SignIn>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ForceFullScreen {
                    VStack {
                        Spacer()
                        
                        signInPersonImage()
                        
                        Spacer()
                        
                        emailTextField(
                            text: viewStore.binding(
                                get: { $0.email},
                                send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                            )
                        )
                        
                        passwordTextField(
                            text: viewStore.binding(
                                get: { $0.password },
                                send: { .internal(.passwordFieldReceivingInput(text: $0)) }
                            )
                        )
                        .padding(.bottom)
                        
                        actionButton(
                            text: "Login",
                            action: { viewStore.send(.login(.loginButtonTapped), animation: .default) },
                            isDisabled: { viewStore.state.disableButton }
                        )
                        
                        secondaryActionButton(
                            text: "Create Account",
                            action: { viewStore.send(.delegate(.signUpButtonTapped), animation: .default) }
                        )
                        
                    }
                    
                    .alert(
                        self.store.scope(
                                state: \.alert
                            ),
                        dismiss: .internal(.alertConfirmTapped)
                    )
                }
            }
        }
        
    }
}
