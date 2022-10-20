import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel

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
                    
                    TextField("Email",
                              text: viewStore.binding(
                                get: { $0.email},
                                send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                              )
                    )
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: { $0.password },
                                    send: { .internal(.passwordFieldReceivingInput(text: $0)) }
                                )
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    
                    Button("Login") {
                        viewStore.send(.internal(.loginButtonPressed), animation: .default)
                    }
                    .buttonStyle(.primary(isLoading: viewStore.state.isLoginInFlight))
                    .cornerRadius(25)
                    .padding()
                    
                    Button("Sign Up") {
                        viewStore.send(.internal(.signUpButtonPressed))
                    }
                    .buttonStyle(.secondary(cornerRadius: 25))
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

