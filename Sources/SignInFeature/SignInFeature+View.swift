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
                        
                        signInPersonImage()
                        
                        VStack {
                            Text("Login")
                        }
                        
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
                        
                        Button("Login") {
                            viewStore.send(.internal(.loginButtonPressed), animation: .default)
                        }
                        .buttonStyle(.primary(isDisabled: viewStore.state.isLoginInFlight))
                        .cornerRadius(25)
                        
                        Button("Create Account") {
                            viewStore.send(.delegate(.userPressedSignUp), animation: .default)
                        }
                        .transition(.move(edge: .leading))
                        .foregroundColor(Color("Secondary"))
                        .bold()
                        .padding()
                    }
                    
                    .alert(
                        self
                            .store
                            .scope(
                                state: \.alert
                            ),
                        dismiss: .internal(.alertConfirmTapped)
                    )
                }
            }
        }
        
    }
}




