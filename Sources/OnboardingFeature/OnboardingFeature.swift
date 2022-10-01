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
import SiteRouter
import _URLRouting
import URLRoutingClient


/// Add to check UserDefaults if its the first time they open app -> Show onboarding
public struct Onboarding: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.urlRoutingClient) var urlRoutingClient
    
    public init() {}
}

public extension Onboarding {
    
    struct State: Equatable, Sendable {
        public var step: Step
        public var emailAddressField: String
        public var passwordField: String
        public var isLoginInFlight: Bool
        public var areTermsAndConditionsAccepted: Bool
        public var defaultCurrency: DefaultCurrency
        
        public init(
            step: Step = .step0_LoginOrCreateUser,
            emailAddressField: String = "",
            passwordField: String = "",
            isLoginInFlight: Bool = false,
            areTermsAndConditionsAccepted: Bool = false,
            defaultCurrency: DefaultCurrency = .SEK
        ) {
            self.step = step
            self.emailAddressField = emailAddressField
            self.passwordField = passwordField
            self.isLoginInFlight = isLoginInFlight
            self.areTermsAndConditionsAccepted = areTermsAndConditionsAccepted
            self.defaultCurrency = defaultCurrency
        }
        
        
        public enum Step: Int, Equatable, CaseIterable, Comparable, Sendable {
            case step0_LoginOrCreateUser
            case step1_Welcome
            case step2_FillInYourInformation
            case step3_TermsAndConditions
            
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
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        
        public enum InternalAction: Equatable, Sendable {
            case emailAddressFieldReceivingInput(text: String)
            case passwordFieldReceivingInput(text: String)
            case loginButtonPressed
            case signUpButtonPressed
            case nextStep
            case previousStep
            case finishSignUp
            case goBackToLoginView
            case termsAndConditionsBoxPressed
            case defaultCurrencyChosen(DefaultCurrency)
            case sendUserDataToServer(UserModel)
            case userDataServerResponse(TaskResult<String>)
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(DefaultCurrency, token: String)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case let .internal(.emailAddressFieldReceivingInput(text: text)):
                state.emailAddressField = text
                return .none
                
            case let .internal(.passwordFieldReceivingInput(text: text)):
                state.passwordField = text
                return .none
                
            case .internal(.loginButtonPressed):
                state.isLoginInFlight = true
                return .none
                
            case .internal(.signUpButtonPressed):
                state.step = .step1_Welcome
                return .none
                
            case .internal(.nextStep):
                state.step.nextStep()
                return .none
                
            case .internal(.previousStep):
                state.step.previousStep()
                return .none
                
            case .internal(.finishSignUp):
                return .run { [
                    userDefaultsClient,
                    currency = state.defaultCurrency,
                    email = state.emailAddressField,
                    password = state.passwordField
                ] send in
                    
                    await send(.internal(.sendUserDataToServer(
                        .init(username: email, password: password, secret: "?E(H+KbeShVmYq3t6w9z$C&F)J@NcQfT")))
                    )
                    
                    await userDefaultsClient.setIsLoggedIn(true)
                    
                    await userDefaultsClient.setDefaultCurrency(currency.rawValue)
                    
                }
                
            case .internal(.termsAndConditionsBoxPressed):
                state.areTermsAndConditionsAccepted.toggle()
                return .none
                
            case let .internal(.defaultCurrencyChosen(currency)):
                state.defaultCurrency = currency
                return .none
                
            case .internal(.goBackToLoginView):
                state = .init()
                return .none
                
            case let .internal(.sendUserDataToServer(user)):
                return .run { [urlRoutingClient] send in
                    do {
                        return await send(.internal(
                            .userDataServerResponse(
                                TaskResult {
                                    try await urlRoutingClient.decodedResponse(
                                        for: .login(user),
                                        as: LoginResponse.self
                                    ).value.token
                                }
                            )
                        )
                        )
                    }
                }
                
            case let .internal(.userDataServerResponse(result)):
                let token = (try? result.value) ?? "Empty token Implement logic here"
                return .run { [mainQueue, currency = state.defaultCurrency] send in
                    try await mainQueue.sleep(for: .milliseconds(700))
                    await send(.delegate(.userFinishedOnboarding(currency, token: token)))
                }
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
                
            }
        }
    }
}


