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
import UserModel

extension AlertState: @unchecked Sendable {}


/// Add to check UserDefaults if its the first time they open app -> Show onboarding
public struct Onboarding: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.urlRoutingClient) var apiClient
    
    public init() {}
}

public extension Onboarding {
    
    struct State: Equatable, Sendable {
        public var step: Step
        public var passwordField: String
        public var isLoginInFlight: Bool
        public var areTermsAndConditionsAccepted: Bool
        public var user: User
        public var alert: AlertState<Action>?
        public var userSettings: UserSettings
        
        public var passwordFulfillsRequirements: Bool {
            if passwordField.count > 5 {
                return true
            }
            return false
        }
        
        public var emailFulfillsRequirements: Bool {
            guard user.email.count > 5 else {
                return false
            }
            
            guard user.email.contains("@") else {
                return false
            }
            return true
        }
        
        public var disableButton: Bool {
            if !passwordFulfillsRequirements || !emailFulfillsRequirements || isLoginInFlight {
                return true
            } else {
                return false
            }
        }
        
        public init(
            step: Step = .step0_LoginOrCreateUser,
            passwordField: String = "",
            isLoginInFlight: Bool = false,
            areTermsAndConditionsAccepted: Bool = false,
            user: User = .init(email: "", password: "", jwt: ""),
            alert: AlertState<Action>? = nil,
            userSettings: UserSettings  = .init()
        ) {
            self.step = step
            self.passwordField = passwordField
            self.isLoginInFlight = isLoginInFlight
            self.areTermsAndConditionsAccepted = areTermsAndConditionsAccepted
            self.user = user
            self.alert = alert
            self.userSettings = userSettings
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
    
    typealias JWT = String
    
    enum Action: Equatable, Sendable {
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        
        public enum InternalAction: Equatable, Sendable {
            case emailAddressFieldReceivingInput(text: String)
            case passwordFieldReceivingInput(text: String)
            case loginButtonPressed
            case loginResponse(TaskResult<JWT>)
            case signUpButtonPressed
            case nextStep
            case previousStep
            case finishSignUp
            case goBackToLoginView
            case termsAndConditionsBoxPressed
            case defaultCurrencyChosen(Currency)
            case createUserRequest(User)
            case createUserResponse(TaskResult<JWT>)
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(jwt: JWT)
            case userLoggedIn(jwt: JWT)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case let .internal(.emailAddressFieldReceivingInput(text: text)):
                state.user.email = text
                return .none
                
            case let .internal(.passwordFieldReceivingInput(text: text)):
                state.passwordField = text
                state.user.password = text
                return .none
                
            case .internal(.loginButtonPressed):
                state.isLoginInFlight = true
                
                return .run { [apiClient, user = state.user] send in
                    return await send(.internal(.loginResponse(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .login(user),
                                as: ResultPayload<JWT>.self
                            ).value.status.get()
                        }
                    )))
                }
                
            case let .internal(.loginResponse(.success(jwt))):
                state.isLoginInFlight = false
                
                return .run { [userDefaultsClient] send in
                    await userDefaultsClient.setIsLoggedIn(true)
                    await userDefaultsClient.setLoggedInUserJWT(jwt)
                    await send(.delegate(.userLoggedIn(jwt: jwt)))
                }
                
                
            case let .internal(.loginResponse(.failure(error))):
                state.isLoginInFlight = false
                state.alert = AlertState(
                     title: TextState("Error"),
                     message: TextState(error.localizedDescription),
                     dismissButton: .cancel(TextState("Dismiss"), action: .none)
                 )
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
                    user = state.user,
                    userSettings = state.userSettings
                ] send in
                    
                    await send(.internal(.createUserRequest(user)))
                    
                    await userDefaultsClient.setIsLoggedIn(true)
                    
                    await userDefaultsClient.setDefaultCurrency(userSettings.defaultCurrency.rawValue)
                    
                }
                
            case .internal(.termsAndConditionsBoxPressed):
                state.areTermsAndConditionsAccepted.toggle()
                return .none
                
                // TODO: Make this a part of User model instead.
            case let .internal(.defaultCurrencyChosen(currency)):
                state.userSettings.defaultCurrency = currency
                return .none
                
            case .internal(.goBackToLoginView):
                state = .init()
                return .none
                
            case let .internal(.createUserRequest(user)):
                
                return .run { [apiClient] send in
                        return await send(.internal(
                            .createUserResponse(
                                TaskResult {
                                    try await apiClient.decodedResponse(
                                        for: .create(user),
                                        as: ResultPayload<JWT>.self
                                    ).value.status.get()
                                }
                            )
                        )
                        )
                    
                }
                
            case let .internal(.createUserResponse(.success(jwt))):
                return .run { [mainQueue, userDefaultsClient] send in
                    try await mainQueue.sleep(for: .milliseconds(700))
                    await userDefaultsClient.removeLoggedInUserJWT()
                    await userDefaultsClient.setLoggedInUserJWT(jwt)
                    await send(.delegate(.userFinishedOnboarding(jwt: jwt)))
                }
                
            case .internal(.alertConfirmTapped):
                state.alert = nil
                return .none
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
                
            }
        }
    }
}

//public func doesEmailMeetRequirements(email: String) -> Bool? {
//    guard let regex = try? Regex(#"^[^\s@]+@([^\s@.,]+\.)+[^\s@.,]{2,}$"#) else { return nil }
//    if email.wholeMatch(of: regex) != nil {
//        return true
//    }
//    return false
//}
