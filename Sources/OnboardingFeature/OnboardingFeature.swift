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
    
    struct State: Equatable, Sendable {
        public var step: Step
        public var emailAddressField: String
        public var passwordField: String
        public var isLoginInFlight: Bool
        public var areTermsAndConditionsAccepted: Bool
        public var defaultCurrency: String
        
        public init(
            step: Step = .step0_LoginOrCreateUser,
            emailAddressField: String = "",
            passwordField: String = "",
            isLoginInFlight: Bool = false,
            areTermsAndConditionsAccepted: Bool = false,
            defaultCurrency: String = "SEK"
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
        case termsAndConditionsBoxPressed
        case defaultCurrencyChosen(currency: String)
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
                return .run { [userDefaultsClient, currency = state.defaultCurrency] _ in
                    await userDefaultsClient.setIsLoggedIn(true)
                    await userDefaultsClient.setDefaultCurrency(currency)
                }
                
            case .termsAndConditionsBoxPressed:
                state.areTermsAndConditionsAccepted.toggle()
                return .none
                
            case let .defaultCurrencyChosen(currency):
                state.defaultCurrency = currency
                return .none
            }
        }
    }
}


