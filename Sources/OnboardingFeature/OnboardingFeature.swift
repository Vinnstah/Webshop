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
        public var user: User?
        public var alert: AlertState<Action>?
        public var userSettings: UserSettings
        public var email: String
        public var password: String
        
        ///Rudimentary check to see if password exceeds 5 charachters. Will be replace by more sofisticated check later on.
        public var passwordFulfillsRequirements: Bool {
            if password.count > 5 {
                return true
            }
            return false
        }
        ///Check to see if email exceeds 5 charachters and if it contains `@`. Willl be replaced by RegEx.
        public var emailFulfillsRequirements: Bool {
            guard email.count > 5 else {
                return false
            }
            
            guard email.contains("@") else {
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
            user: User? = nil,
            alert: AlertState<Action>? = nil,
            userSettings: UserSettings  = .init(),
            email: String = "",
            password: String = ""
        ) {
            self.step = step
            self.isLoginInFlight = isLoginInFlight
            self.areTermsAndConditionsAccepted = areTermsAndConditionsAccepted
            self.user = user
            self.alert = alert
            self.userSettings = userSettings
            self.email = email
            self.password = password
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
                ///Set `email` when emailField recceives input
            case let .internal(.emailAddressFieldReceivingInput(text: text)):
                state.email = text
                return .none
                
                ///Set  `password` when passwordField receives input.
            case let .internal(.passwordFieldReceivingInput(text: text)):
                state.password = text
                return .none
                
                /// When loginButton is pressed set `loginInFlight` to `true`. Send a api request to login endpoint with `state.user` and receive the TaskResult back.
            case .internal(.loginButtonPressed):
                state.isLoginInFlight = true
                state.user = User(email: state.email, password: state.password, jwt: "")
                
                return .run { [apiClient, user = state.user] send in
                    guard let user else {
                       return await send(.internal(.loginResponse(.failure(ClientError.failedToLogin("No user found")))))
                    }
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
                    
                    /// Set `LoggedInUserJWT` in `userDefaults` to the `jwt` we received back from the server
                    await userDefaultsClient.setLoggedInUserJWT(jwt)
                    /// Delegate the action `userLoggedIn` with the given `jwt`
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
                
                /// We move to the Welcome step when `signUpButton` is pressed
            case .internal(.signUpButtonPressed):
                state.step = .step1_Welcome
                return .none
                
                /// Move to the next step
            case .internal(.nextStep):
                state.step.nextStep()
                return .none
                
                /// Move to the previous step
            case .internal(.previousStep):
                state.step.previousStep()
                return .none
                
                /// When user has finished onboarding we:
            case .internal(.finishSignUp):
                state.user = User(email: state.email, password: state.password, jwt: "")
                return .run { [
                    userDefaultsClient,
                    user = state.user,
                    userSettings = state.userSettings
                ] send in
                    guard let user else {
                        return await send(.internal(.createUserResponse(.failure(ClientError.failedToCreateUser("No user found")))))
                    }
                    /// Set the `defaultCurrency` to the chosen currency
                    await userDefaultsClient.setDefaultCurrency(userSettings.defaultCurrency.rawValue)
                    /// Delegate to the `createUserRequest` action with the currenct `user`
                    await send(.internal(.createUserRequest(user)))
                    
                }
                
                /// Toggle a bool when `termsAndConditionsBox` is pressed in order to update UI
            case .internal(.termsAndConditionsBoxPressed):
                state.areTermsAndConditionsAccepted.toggle()
                return .none
                
                // TODO: Make this a part of User model instead.
            case let .internal(.defaultCurrencyChosen(currency)):
                state.userSettings.defaultCurrency = currency
                return .none
                
                /// Go back to the `LoginView` when the user clicks `cancel`
            case .internal(.goBackToLoginView):
                state = .init()
                return .none
                
                /// Create User request sends a request to the server endpoint `create` with the given `user`. The server then respons with a `ResultPayload` that either gives us a `jwt` for the user if the request is successful or throws an error if it's not.
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
                
                /// If the `createUserRequest` is successfull we receive a `jwt` back in the response
            case let .internal(.createUserResponse(.success(jwt))):
                return .run { [mainQueue, userDefaultsClient] send in
                    try await mainQueue.sleep(for: .milliseconds(700))
                    /// First we remove the saved `jwt` from `userDefaults`, if there is any.
                    await userDefaultsClient.removeLoggedInUserJWT()
                    /// Then we add the newly received `jwt` to `userDefaults`
                    await userDefaultsClient.setLoggedInUserJWT(jwt)
                    /// We delegate the action back to `AppFeature` that the user has finished onboarding and provide the `jwt`
                    await send(.delegate(.userFinishedOnboarding(jwt: jwt)))
                }
                
                /// If the `createUserRequest` fails we show an error
            case let .internal(.createUserResponse(.failure(error))):
                state.alert = AlertState(
                    title: TextState("Error"),
                    message: TextState(error.localizedDescription),
                    dismissButton: .cancel(TextState("Dismiss"), action: .none)
                )
                return .none
                
                /// When the user clicks confirm on the alert we set the `state.alert` to `nil` to remove the alert
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

public enum ClientError: Error, Equatable {
    case failedToLogin(String)
    case failedToCreateUser(String)
}
