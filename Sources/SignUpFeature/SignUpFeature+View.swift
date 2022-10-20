
import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel

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
                        HStack {
                            Text("Email")
                                .font(.subheadline)
                            
                            Spacer()
                        }
                        HStack {
                            TextField("",
                                      text: viewStore.binding(
                                        get: { $0.email },
                                        send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                                      )
                            )
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .foregroundColor(Color("Secondary"))
                            .padding(.bottom)
                            
                            Image(systemName: viewStore.state.emailFulfillsRequirements ? "checkmark" : "xmark")
                                .padding(.bottom)
                                .foregroundColor(Color("Complementary"))
                        }
                        
                        HStack {
                            Text("Password")
                                .font(.subheadline)
                            
                            Spacer()
                        }
                        
                        HStack {
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
                            
                            Image(systemName: viewStore.state.passwordFulfillsRequirements ? "checkmark" : "xmark")
                                .padding(.bottom)
                                .foregroundColor(Color("Complementary"))
                            
                        }
                        
                        VStack {
                            Button("Next step") {
                                viewStore.send(.internal(.nextStep), animation: .default)
                            }
                            .buttonStyle(.primary(isDisabled: viewStore.disableButton, cornerRadius: 25))
                            .disabled(viewStore.state.disableButton)
                            
                            Button("Go Back") { viewStore.send(.delegate(.goToThePreviousStep), animation: .default)}
                                .foregroundColor(Color("Secondary"))
                                .bold()
                                .padding()
                        }
                    }
                    
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                viewStore.send(.delegate(.goBackToLoginView), animation: .default)
                            }
                        }
                    }
                }
            }
        }
    }
}
