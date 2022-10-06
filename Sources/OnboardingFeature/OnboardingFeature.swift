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

///Conforming AlertState to Sendable
extension AlertState: @unchecked Sendable {}


public struct Onboarding: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.urlRoutingClient) var apiClient
    
    public init() {}
}

public extension Onboarding {
    
    struct State: Equatable, Sendable {
        public var step: Step
        public var isLoginInFlight: Bool
        public var areTermsAndConditionsAccepted: Bool
        public var user: User
        public var alert: AlertState<Action>?
        public var userSettings: UserSettings
        
        ///Rudimentary check to see if password exceeds 5 charachters. Will be replace by more sofisticated check later on.
        public var passwordFulfillsRequirements: Bool {
            if user.password.count > 5 {
                return true
            }
            return false
        }
        ///Check to see if email exceeds 5 charachters and if it contains `@`. Willl be replaced by RegEx.
        public var emailFulfillsRequirements: Bool {
            guard user.email.count > 5 else {
                return false
            }
            
            guard user.email.contains("@") else {
                return false
            }
            return true
        }
        
        ///If either of the 3 conditions are `false` we return `true` and can disable specific buttons.
        public var disableButton: Bool {
            if !passwordFulfillsRequirements || !emailFulfillsRequirements || isLoginInFlight {
                return true
            } else {
                return false
            }
        }
        
        public init(
            step: Step = .step0_LoginOrCreateUser,
            isLoginInFlight: Bool = false,
            areTermsAndConditionsAccepted: Bool = false,
            user: User = .init(email: "", password: "", jwt: ""),
            alert: AlertState<Action>? = nil,
            userSettings: UserSettings  = .init()
        ) {
            self.step = step
            self.isLoginInFlight = isLoginInFlight
            self.areTermsAndConditionsAccepted = areTermsAndConditionsAccepted
            self.user = user
            self.alert = alert
            self.userSettings = userSettings
        }
        
        ///Enum for the different Onboarding steps.
        public enum Step: Int, Equatable, CaseIterable, Comparable, Sendable {
            case step0_LoginOrCreateUser
            case step1_Welcome
            case step2_FillInYourInformation
            case step3_TermsAndConditions
            
            ///Function to skip to the next step
            mutating func nextStep() {
                self = Self(rawValue: self.rawValue + 1) ?? Self.allCases.last!
            }
            ///Function to go back to the previous step
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
                ///Set user.email when emailField recceives input
            case let .internal(.emailAddressFieldReceivingInput(text: text)):
                state.user.email = text
                return .none
            
                ///Set  `user.password` when passwordField receives input.
            case let .internal(.passwordFieldReceivingInput(text: text)):
                state.user.password = text
                return .none
                
                /// When loginButton is pressed set `loginInFlight` to `true`. Send a api request to login endpoint with `state.user` and receive the TaskResult back.
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
                
                /// If login is successful we set `loginInFlight` to `false`. We then set userDefaults `isLoggedIn` to `true` and add the user JWT.
            case let .internal(.loginResponse(.success(jwt))):
                state.isLoginInFlight = false
                
                return .run { [userDefaultsClient] send in
                    await userDefaultsClient.setIsLoggedIn(true)
                    await userDefaultsClient.setLoggedInUserJWT(jwt)
                    await send(.delegate(.userLoggedIn(jwt: jwt)))
                }
                
                /// If login fails we show an alert.
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
                
            case let .internal(.createUserResponse(.failure(error))):
                state.alert = AlertState(
                     title: TextState("Error"),
                     message: TextState(error.localizedDescription),
                     dismissButton: .cancel(TextState("Dismiss"), action: .none)
                 )
                return .none
                
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
