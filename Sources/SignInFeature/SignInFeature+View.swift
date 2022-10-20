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
                        HStack {
                            Text("Email")
                                .font(.subheadline)
                            
                            Spacer()
                        }
                        
                        TextField("",
                                  text: viewStore.binding(
                                    get: { $0.email},
                                    send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                                  )
                        )
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(Color("Secondary"))
                        .padding(.bottom)
                        
                        HStack {
                            Text("Password")
                                .font(.subheadline)
                            
                            Spacer()
                        }
                        
                        SecureField("",
                                    text: viewStore.binding(
                                        get: { $0.password },
                                        send: { .internal(.passwordFieldReceivingInput(text: $0)) }
                                    )
                        )
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(Color("Secondary"))
                        .padding(.bottom)
                        
                        Button("Log in") {
                            viewStore.send(.internal(.loginButtonPressed), animation: .default)
                        }
                        .buttonStyle(.primary(isDisabled: viewStore.state.isLoginInFlight))
                        .cornerRadius(25)
                        
                        Button("Sign Up") {
                            viewStore.send(.internal(.signUpButtonPressed), animation: .default)
                        }
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

