//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-24.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient

/// Add to check UserDefaults if its the first time they open app -> Show onboarding


public struct Onboarding: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    public init() {}
}

public extension Onboarding {
    
    struct State: Equatable {
        public var step: Step
        public var emailAddressField: String
        public var passwordField: String
        public var isLoginInFlight: Bool
        
        public init(
            step: Step = .step0_LoginOrCreateUser,
            emailAddressField: String = "",
            passwordField: String = "",
            isLoginInFlight: Bool = false
        ) {
            self.step = step
            self.emailAddressField = emailAddressField
            self.passwordField = passwordField
            self.isLoginInFlight = isLoginInFlight
        }
        
        
        public enum Step: Int, Equatable, CaseIterable, Comparable {
            case step0_LoginOrCreateUser
            case step1_Welcome
            case step2_FillInYourInformation
            case step3_UsernameAndPassword
            case step4_TermsAndConditions
            
            mutating func nextStep() {
                self = Self(rawValue: self.rawValue + 1) ?? Self.allCases.last!
            }
            
            mutating func previousStep() {
                self = Self(rawValue: self.rawValue - 1) ?? Self.allCases.first!
            }
            
            public static func < (lhs: Self, rhs: Self) -> Bool {
                lhs.rawValue < rhs.rawValue
            }
        }
    }
    
    enum Action: Equatable, Sendable {
        case emailAddressFieldReceivingInput(text: String)
        case passwordFieldReceivingInput(text: String)
        case loginButtonPressed
        case signUpButtonPressed
        case nextStep
        case previousStep
        case finishSignUp
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case let .emailAddressFieldReceivingInput(text: text):
                state.emailAddressField = text
                return .none
                
            case let .passwordFieldReceivingInput(text: text):
                state.passwordField = text
                return .none
                
            case .loginButtonPressed:
                state.isLoginInFlight = true
                return .none
                
            case .signUpButtonPressed:
                state.step = .step1_Welcome
                return .none
                
            case .nextStep:
                state.step.nextStep()
                return .none
                
            case .previousStep:
                state.step.previousStep()
                return .none
                
            case .finishSignUp:
                return .run { _ in
                    await userDefaultsClient.setIsLoggedIn(true)
                }
            }
        }
    }
}


public extension Onboarding {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Onboarding>
        
        public init(store: StoreOf<Onboarding>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Group {
                    if viewStore.state.step == .step0_LoginOrCreateUser {
                        OnboardingLoginView(store: store)
                    }
                    if viewStore.state.step == .step1_Welcome {
                        OnboardingSignUpView(store: store)
                    }
                    if viewStore.state.step == .step2_FillInYourInformation {
                        Text("View to fill in all information")
                        
                        Button("Next step") {
                            viewStore.send(.nextStep)
                        }
                        if viewStore.state.step != .step1_Welcome {
                            Button("Previous Step") { viewStore.send(.previousStep)}
                        }
                    }
                    if viewStore.state.step == .step3_UsernameAndPassword {
                        Text("View to set Username and Password")
                        
                        Button("Next step") {
                            viewStore.send(.nextStep)
                        }
                        if viewStore.state.step != .step1_Welcome {
                            Button("Previous Step") { viewStore.send(.previousStep)}
                        }
                    }
                    if viewStore.state.step == .step4_TermsAndConditions {
                        Text("Accept T&C")
                        
                        Button("Finish Sign Up") {
                            viewStore.send(.finishSignUp)
                        }
                        if viewStore.state.step != .step1_Welcome {
                            Button("Previous Step") { viewStore.send(.previousStep)}
                        }
                    }
                }
            }
            
            
        }
    }
}

public struct OnboardingLoginView: SwiftUI.View {
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
                //
                SecureField("Password",
                            text: viewStore.binding(
                                get: { $0.passwordField },
                                send: { .passwordFieldReceivingInput(text: $0) }
                            )
                )
                .padding()
                
                Button("Login") {
                    viewStore.send(.loginButtonPressed)
                }
                
                Button("Sign Up") {
                    viewStore.send(.signUpButtonPressed)
                }
            }
        }
    }
}

public struct OnboardingSignUpView: SwiftUI.View {
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
                        Button("Previous Step") { viewStore.send(.previousStep)}
                    }
                }
                
            }
        }
    }
}
