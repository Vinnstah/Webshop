import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel
import SignUpFeature
import UserLocalSettingsFeature
import TermsAndConditionsFeature
import SignInFeature

///Conforming AlertState to Sendable
extension AlertState: @unchecked Sendable {}

public struct Onboarding: ReducerProtocol {
    
    public init() {}
}

public extension Onboarding {
    
    struct State: Equatable, Sendable {
        public var signIn: SignIn.State?
        public var signUp: SignUp.State?
        public var userLocalSettings: UserLocalSettings.State?
        public var termsAndConditions: TermsAndConditions.State?
        public var alert: AlertState<Action>?
        
        
        public init(
            signIn: SignIn.State? = .init(),
            signUp: SignUp.State? = nil,
            userLocalSettings: UserLocalSettings.State? = nil,
            termsAndConditions: TermsAndConditions.State? = nil,
            alert: AlertState<Action>? = nil
        ) {
            self.signIn = signIn
            self.signUp = signUp
            self.userLocalSettings = userLocalSettings
            self.termsAndConditions = termsAndConditions
            self.alert = alert
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
            case alertConfirmTapped
            case goBackToLoginViewTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(jwt: JWT)
            case userLoggedIn(jwt: JWT)
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        CombineReducers {
            Reduce(self.`internal`)
            Reduce(self.signIn)
                .ifLet(\.signIn, action: /Action.signIn) {
                    SignIn()
                }
            Reduce(self.signUp)
                .ifLet(\.signUp, action: /Action.signUp) {
                    SignUp()
                }
            Reduce(self.userLocalSettings)
                .ifLet(\.userLocalSettings, action: /Action.userLocalSettings) {
                    UserLocalSettings()
                }
            Reduce(self.termsAndConditions)
                .ifLet(\.termsAndConditions, action: /Action.termsAndConditions) {
                    TermsAndConditions()
                }
        }
    }
}

public extension Onboarding {
    func `internal`(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .internal(.goBackToLoginViewTapped):
            state.signIn = .init()
            return .none
            
        case .internal(.alertConfirmTapped):
            state.alert = nil
            return .none
        case .delegate(_):
            return  .none
        case .internal(_):
            return  .none
        case .signIn(_):
            return .none
        case .signUp(_):
            return .none
        case .userLocalSettings(_):
            return .none
        case .termsAndConditions(_):
            return .none
        }
    }
}
