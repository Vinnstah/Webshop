//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-10-08.
//

import Foundation
import ComposableArchitecture
import SwiftUI


public extension Login {
    struct View: SwiftUI.View {
        public let store: StoreOf<Login>
        
        public init(store: StoreOf<Login>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    TextField("Email",
                              text: viewStore.binding(
                                get: { $0.email},
                                send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                              )
                    )
                    .padding()
                    
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: { $0.password },
                                    send: { .internal(.passwordFieldReceivingInput(text: $0)) }
                                )
                    )
                    .padding()
                    
                    Button("Login") {
                        viewStore.send(.internal(.loginButtonPressed), animation: .default)
                    }
                    .disabled(viewStore.state.isLoginInFlight)
                    
                    Button("Sign Up") {
                        viewStore.send(.internal(.signUpButtonPressed))
                    }
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
