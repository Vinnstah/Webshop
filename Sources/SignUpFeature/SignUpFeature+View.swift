//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-10-07.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public extension SignUp {
     struct View: SwiftUI.View {
        public let store: StoreOf<SignUp>
        
        public init(store: StoreOf<SignUp>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Text("WELCOME TO SIGNUP")
                VStack {
                    TextField("Email",
                              text: viewStore.binding(
                                get: { $0.email },
                                send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                              )
                    )
                    .padding(.horizontal)
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: { $0.password },
                                    send: { .internal(.passwordFieldReceivingInput(text: $0)) }
                                )
                    )
                    .padding(.horizontal)
                    if !viewStore.state.emailFulfillsRequirements {
                        Text("Email does not meet requirements")
                    }
                    if !viewStore.state.passwordFulfillsRequirements {
                        Text("Password does not meet requirements")
                    }
                    HStack {
                        Button("Next step") {
                            viewStore.send(.internal(.nextStep), animation: .default)
                        }
                        .disabled(viewStore.state.disableButton)
                        
                        Button("Previous Step") { viewStore.send(.delegate(.goToThePreviousStep), animation: .default)}
                        
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
