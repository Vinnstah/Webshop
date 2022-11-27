
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
                            .autocorrectionDisabled()
                            .foregroundColor(Color("Secondary"))
                            .padding(.bottom)
                            
                            Image(systemName: viewStore.state.emailFulfillsRequirements ? "checkmark" : "xmark")
                                .padding(.bottom)
                                .foregroundColor(viewStore.state.emailFulfillsRequirements ? .green : .red)
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
                            .textFieldStyle(.roundedBorder)
                            .foregroundColor(Color("Secondary"))
                            .padding(.bottom)
                            
                            Image(systemName: viewStore.state.passwordFulfillsRequirements ? "checkmark" : "xmark")
                                .padding(.bottom)
                                .foregroundColor(viewStore.state.passwordFulfillsRequirements ? .green : .red)
                            
                        }
                        
                        VStack {
                            Button("Next step") {
                                viewStore.send(.delegate(.goToNextStep(viewStore.state.user)), animation: .default)
                            }
                            .buttonStyle(.primary(isDisabled: viewStore.disableButton, cornerRadius: 25))
                            .disabled(viewStore.state.disableButton)
                            .transition(.move(edge: .leading))
                            
                            Button("Go Back") { viewStore.send(.delegate(.goToThePreviousStep), animation: .default)}
                                .foregroundColor(Color("Secondary"))
                                .bold()
                                .padding()
                        }
                    }
                }
            }
        }
    }
}
