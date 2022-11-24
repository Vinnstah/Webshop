import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel
import SignUpFeature
import UserLocalSettingsFeature
import TermsAndConditionsFeature
import SignInFeature

public struct Onboarding: ReducerProtocol {
    public init() {}
}

public extension Onboarding {
    
    struct State: Equatable, Sendable {
        public var signIn: SignIn.State?
        public var signUp: SignUp.State?
        public var userLocalSettings: UserLocalSettings.State?
        public var termsAndConditions: TermsAndConditions.State?


        public init(
            signIn: SignIn.State? = .init(),
            signUp: SignUp.State? = nil,
            userLocalSettings: UserLocalSettings.State? = nil,
            termsAndConditions: TermsAndConditions.State? = nil
        ) {
            self.signIn = signIn
            self.signUp = signUp
            self.userLocalSettings = userLocalSettings
            self.termsAndConditions = termsAndConditions
        }
    }
    
    typealias JWT = String
    
    enum Action: Equatable, Sendable {
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        case signIn(SignIn.Action)
        case signUp(SignUp.Action)
        case userLocalSettings(UserLocalSettings.Action)
        case termsAndConditions(TermsAndConditions.Action)
        
        public enum InternalAction: Equatable, Sendable {
            case goBackToSignInViewTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(with: JWT)
            case userLoggedIn(with: JWT)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        CombineReducers {
            
            Reduce(self.`internal`)
            Reduce(self.signIn)
                .ifLet(
                    \.signIn,
                     action: /Action.signIn
                ) {
                    SignIn()
                }
            
            Reduce(self.signUp)
                .ifLet(
                    \.signUp,
                     action: /Action.signUp
                ) {
                    SignUp()
                }
            
            Reduce(self.userLocalSettings)
                .ifLet(
                    \.userLocalSettings,
                     action: /Action.userLocalSettings
                ) {
                    UserLocalSettings()
                }
            
            Reduce(self.termsAndConditions)
                .ifLet(
                    \.termsAndConditions,
                     action: /Action.termsAndConditions
                ) {
                    TermsAndConditions()
                }
        }
    }
}
