//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-25.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient
import UserModel

public extension Onboarding {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Group {
                    switch viewStore.step {
                    case .step0_LoginOrCreateUser:
                        Onboarding.LoginView(store: store)
                        
                    case .step1_Welcome:
                        Onboarding.WelcomeView(store: store)
                        
                    case .step2_FillInYourInformation:
                        Onboarding.PersonalInformationView(store: store)
                        
                    case .step3_TermsAndConditions:
                        Onboarding.TermsAndConditionsView(store: store)
                    }
                }
            }
        }
    }
}

public extension Onboarding {
    struct LoginView: SwiftUI.View {
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    TextField("Email",
                              text: viewStore.binding(
                                get: { $0.emailAddressField },
                                send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                              )
                    )
                    .padding()
                    
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: { $0.passwordField },
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

public extension Onboarding {
    struct WelcomeView: SwiftUI.View {
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Text("WELCOME TO SIGNUP")
                VStack {
                    TextField("Email",
                              text: viewStore.binding(
                                get: { $0.emailAddressField },
                                send: { .internal(.emailAddressFieldReceivingInput(text: $0)) }
                              )
                    )
                    .padding()
                    //
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: { $0.passwordField },
                                    send: { .internal(.passwordFieldReceivingInput(text: $0)) }
                                )
                    )
                    .padding()
                    HStack {
                        Button("Next step") {
                            viewStore.send(.internal(.nextStep))
                        }
                        if viewStore.state.step != .step1_Welcome {
                            Button("Previous Step") { viewStore.send(.internal(.previousStep), animation: .easeIn(duration: 1.0))}
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.internal(.goBackToLoginView))
                        }
                    }
                }
            }
        }
    }
}

public extension Onboarding {
    struct PersonalInformationView: SwiftUI.View {
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("View to fill in all information")
                    
                    Picker("Default Currency", selection: viewStore.binding(
                        get: { $0.user.userSettings.defaultCurrency },
                        send: { .internal(.defaultCurrencyChosen($0)) }
                    )
                    ) {
                        ForEach(Currency.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .padding()
                    
                    Button("Next step") {
                        viewStore.send(.internal(.nextStep))
                    }
                    if viewStore.state.step != .step1_Welcome {
                        Button("Previous Step") { viewStore.send(.internal(.previousStep))}
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.internal(.goBackToLoginView))
                        }
                    }
                }
            }
        }
    }
}


public extension Onboarding {
    struct TermsAndConditionsView: SwiftUI.View {
        
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    ScrollView(.vertical) {
                        Text("""
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        """)
                    }
                    .frame(width: 200, height: 400)
                    
                    HStack {
                        Text("Accept Terms and Conditions")
                        
                        /// This variable should be in a ViewState instead?
                        Image(systemName: viewStore.state.areTermsAndConditionsAccepted ? "checkmark.square" : "square")
                            .onTapGesture {
                                viewStore.send(.internal(.termsAndConditionsBoxPressed))
                            }
                    }
                    
                    Button("Finish Sign Up") {
                        viewStore.send(.internal(.finishSignUp))
                    }
                    .disabled(!viewStore.areTermsAndConditionsAccepted)
                    
                    if viewStore.state.step != .step1_Welcome {
                        Button("Previous Step") { viewStore.send(.internal(.previousStep)) }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.internal(.goBackToLoginView))
                        }
                    }
                }
            }
        }
    }
}

