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
import SignUpFeature
import UserInformationFeature
import TermsAndConditionsFeature
import SignInFeature

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
        public var signIn: SignIn.State?
        public var signUp: SignUp.State?
        public var userInformation: UserInformation.State?
        public var termsAndConditions: TermsAndConditions.State?
        public var step: Step
        public var alert: AlertState<Action>?

        
        public init(
            signIn: SignIn.State? = .init(),
            signUp: SignUp.State? = nil,
            userInformation: UserInformation.State? = nil,
            termsAndConditions: TermsAndConditions.State? = nil,
            step: Step = .step0_SignIn,
            alert: AlertState<Action>? = nil
        ) {
            self.signIn = signIn
            self.signUp = signUp
            self.userInformation = userInformation
            self.termsAndConditions = termsAndConditions
            self.step = step
            self.alert = alert
        }
        
        ///Enum for the different Onboarding steps.
        public enum Step: Int, Equatable, CaseIterable, Comparable, Sendable {
            case step0_SignIn
            case step1_SignUp
            case step2_UserSettings
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
            case signIn(SignIn.Action)
            case signUp(SignUp.Action)
            case userInformation(UserInformation.Action)
            case termsAndConditions(TermsAndConditions.Action)
            case alertConfirmTapped
            case nextStep
            case previousStep
            case goBackToLoginView
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(jwt: JWT)
            case userLoggedIn(jwt: JWT)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                /// Move to the next step
            case .internal(.nextStep):
                state.step.nextStep()
                return .none
                
                /// Move to the previous step
            case .internal(.previousStep):
                state.step.previousStep()
                return .none

                /// Go back to the `LoginView` when the user clicks `cancel`
            case .internal(.goBackToLoginView):
                state.step = .step0_SignIn
                state.signIn = .init()
                return .none
                
                /// When the user clicks confirm on the alert we set the `state.alert` to `nil` to remove the alert
            case .internal(.alertConfirmTapped):
                state.alert = nil
                return .none
                
            case let .internal(.signUp(.delegate(.goToNextStep(user)))):
                state.signUp = nil
                state.userInformation = .init(user: user)
                state.step = .step2_UserSettings
                return .none
                
            case .internal(.signUp(.delegate(.goToThePreviousStep))):
                state.signUp = nil
                state.signIn = .init()
                state.step.previousStep()
                return .none
                
            case .internal(.signUp(.delegate(.goBackToLoginView))):
                state.signUp = nil
                return .run { send in
                    await send(.internal(.goBackToLoginView))
                    
                }
            case .internal(.userInformation(.delegate(.goBackToLoginView))):
                state.userInformation = nil
                return .run { send in
                    await send(.internal(.goBackToLoginView))
                }
                
            case let .internal(.userInformation(.delegate(.nextStep(user)))):
                state.userInformation = nil
                state.termsAndConditions = .init(user: user)
                state.step.nextStep()
                return .none
                
            case let .internal(.userInformation(.delegate(.previousStep(user)))):
                state.userInformation = nil
                state.signUp = .init(user: user, email: user.email, password: user.password)
                state.step.nextStep()
                return .none
                
            case let .internal(.termsAndConditions(.delegate(.previousStep(user)))):
                state.termsAndConditions = nil
                state.userInformation = .init(user: user)
                state.step.previousStep()
                return .none
                
            case .internal(.termsAndConditions(.delegate(.goBackToLoginView))):
                state.termsAndConditions = nil
                return .run { send in
                    await send(.internal(.goBackToLoginView))
                }
                
            case .internal(.signIn(.delegate(.userPressedSignUp))):
                state.signIn = nil
                state.signUp = .init()
                state.step = .step1_SignUp
                return .none
                
            case let .internal(.signIn(.delegate(.userLoggedIn(jwt: jwt)))):
                return .run { send in
                    await send(.delegate(.userLoggedIn(jwt: jwt)))
                }
                
            case let .internal(.termsAndConditions(.delegate(.userFinishedOnboarding(jwt)))):
                return .run { send in
                    await send(.delegate(.userFinishedOnboarding(jwt: jwt)))
                }
                
            case .internal(_):
                return .none
            case .delegate(_):
                return .none
            }
        }
        .ifLet(\.signIn, action: /Action.internal(.signIn)) {
            SignIn()
        }
        .ifLet(\.signUp, action: /Action.internal(.signUp)) {
            SignUp()
        }
        .ifLet(\.userInformation, action: /Action.internal(.userInformation)) {
            UserInformation()
        }
        .ifLet(\.termsAndConditions, action: /Action.internal(.termsAndConditions)) {
            TermsAndConditions()
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
//
