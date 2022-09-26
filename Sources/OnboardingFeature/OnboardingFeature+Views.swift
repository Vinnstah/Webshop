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
                        
                    case .step3_UsernameAndPassword:
                        Onboarding.CredentialsView(store: store)
                        
                    case .step4_TermsAndConditions:
                        Onboarding.TermsAndConditionsView(store: store)
                    }
                    //
                    //                    if viewStore.state.step == .step0_LoginOrCreateUser {
                    //                        Onboarding.LoginView(store: store)
                    //                    }
                    //                    if viewStore.state.step == .step1_Welcome {
                    //                        Onboarding.WelcomeView(store: store)
                    //                    }
                    //                    if viewStore.state.step == .step2_FillInYourInformation {
                    //                        Onboarding.PersonalInformationView(store: store)
                    //                    }
                    //                    if viewStore.state.step == .step3_UsernameAndPassword {
                    //                        Onboarding.CredentialsView(store: store)
                    //                    }
                    //                    if viewStore.state.step == .step4_TermsAndConditions {
                    //                        Onboarding.TermsAndConditionsView(store: store)
                    //                    }
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
                                send: { .emailAddressFieldReceivingInput(text: $0) }
                              )
                    )
                    .padding()
                    
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: { $0.passwordField },
                                    send: { .passwordFieldReceivingInput(text: $0) }
                                )
                    )
                    .padding()
                    
                    Button("Login") {
                        viewStore.send(.loginButtonPressed, animation: .default)
                    }
                    
                    Button("Sign Up") {
                        viewStore.send(.signUpButtonPressed)
                    }
                }
                
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
                                send: { .emailAddressFieldReceivingInput(text: $0) }
                              )
                    )
                    .padding()
                    //
                    SecureField("Password",
                                text: viewStore.binding(
                                    get: { $0.passwordField },
                                    send: { .passwordFieldReceivingInput(text: $0) }
                                )
                    )
                    .padding()
                    HStack {
                        Button("Next step") {
                            viewStore.send(.nextStep)
                        }
                        if viewStore.state.step != .step1_Welcome {
                            Button("Previous Step") { viewStore.send(.previousStep, animation: .easeIn(duration: 1.0))}
                        }
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.goBackToLoginView)
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
                        get: { $0.defaultCurrency },
                        send: { .defaultCurrencyChosen($0) }
                    )
                    ) {
                        ForEach(DefaultCurrency.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .padding()
                    
                    Button("Next step") {
                        viewStore.send(.nextStep)
                    }
                    if viewStore.state.step != .step1_Welcome {
                        Button("Previous Step") { viewStore.send(.previousStep)}
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.goBackToLoginView)
                        }
                    }
                }
            }
        }
    }
}

public extension Onboarding {
    struct CredentialsView: SwiftUI.View {
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("View to set Username and Password")
                    
                    Button("Next step") {
                        viewStore.send(.nextStep)
                    }
                    if viewStore.state.step != .step1_Welcome {
                        Button("Previous Step") { viewStore.send(.previousStep)}
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.goBackToLoginView)
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
                                viewStore.send(.termsAndConditionsBoxPressed)
                            }
                    }
                    
                    Button("Finish Sign Up") {
                        viewStore.send(.finishSignUp)
                    }
                    .disabled(!viewStore.areTermsAndConditionsAccepted)
                    
                    if viewStore.state.step != .step1_Welcome {
                        Button("Previous Step") { viewStore.send(.previousStep)}
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.goBackToLoginView)
                        }
                    }
                }
            }
        }
    }
}

