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
    @Dependency(\.urlRoutingClient) var urlRoutingClient
    
    public init() {}
}

public extension Onboarding {
    
    struct State: Equatable, Sendable {
        public var step: Step
        public var isLoginInFlight: Bool
        public var areTermsAndConditionsAccepted: Bool
        public var user: User
        public var alert: AlertState<Action>?
        
        public var passwordFulfillsRequirements: Bool {
            if user.password.count > 5 {
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
            isLoginInFlight: Bool = false,
            areTermsAndConditionsAccepted: Bool = false,
            user: User = .init(email: "", password: "", jwt: "", userSettings: .init()),
            alert: AlertState<Action>? = nil
        ) {
            self.step = step
            self.isLoginInFlight = isLoginInFlight
            self.areTermsAndConditionsAccepted = areTermsAndConditionsAccepted
            self.user = user
            self.alert = alert
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
            case loginResponse(TaskResult<ResultPayload>)
            case signUpButtonPressed
            case nextStep
            case previousStep
            case finishSignUp
            case goBackToLoginView
            case termsAndConditionsBoxPressed
            case defaultCurrencyChosen(Currency)
            case sendUserDataToServer(User)
            case userDataServerResponse(TaskResult<User>)
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(user: User)
            case userLoggedIn(token: String)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case let .internal(.emailAddressFieldReceivingInput(text: text)):
                state.user.email = text
                return .none
                
            case let .internal(.passwordFieldReceivingInput(text: text)):
                state.user.password = text
                return .none
                
            case .internal(.loginButtonPressed):
                state.isLoginInFlight = true
                
                return .run { [urlRoutingClient, user = state.user] send in
                    do {
                        return await send(.internal(.loginResponse(
                            TaskResult {
                                try await urlRoutingClient.decodedResponse(
                                    for: .login(user),
                                    as: ResultPayload.self
                                ).value
                            }
                        )))
                    }
                }
                
            case let .internal(.loginResponse(.success(result))):
                state.isLoginInFlight = false
                switch result.status {
                    
                case .failedToLogin:
                    
                    state.alert = AlertState(
                         title: TextState("Error"),
                         message: TextState(result.data),
                         dismissButton: .cancel(TextState("Dismiss"), action: .none)
                     )
                    return .none
                    
                case .successfulLogin:
                    return .run { [userDefaultsClient] send in
                        await userDefaultsClient.setIsLoggedIn(true)
                        await send(.delegate(.userLoggedIn(token: result.data)))
                    }
                }
                
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
                    user = state.user
                ] send in
                    
                    await send(.internal(.sendUserDataToServer(user)))
                    
                    await userDefaultsClient.setIsLoggedIn(true)
                    
                    await userDefaultsClient.setDefaultCurrency(user.userSettings.defaultCurrency.rawValue)
                    
                }
                
            case .internal(.termsAndConditionsBoxPressed):
                state.areTermsAndConditionsAccepted.toggle()
                return .none
                
                // TODO: Make this a part of User model instead.
            case let .internal(.defaultCurrencyChosen(currency)):
                state.user.userSettings.defaultCurrency = currency
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
                                        for: .create(user),
                                        as: User.self
                                    ).value
                                }
                            )
                        )
                        )
                    }
                }
                
            case let .internal(.userDataServerResponse(result)):
                guard let user = try? result.value else {
                    return .none
                }
                return .run { [mainQueue, userDefaultsClient] send in
                    try await mainQueue.sleep(for: .milliseconds(700))
                    // TODO: DELETE OLD USERDEFAULTS
                    await userDefaultsClient.setLoggedInUser(user)
                    await send(.delegate(.userFinishedOnboarding(user: user )))
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
