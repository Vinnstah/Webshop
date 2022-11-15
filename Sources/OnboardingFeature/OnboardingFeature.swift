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
    func signUp(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case let .signUp(.delegate(.goToNextStep(user))):
            state.signUp = nil
            state.userLocalSettings = .init(user: user)
            return .none
            
        case .signUp(.delegate(.goToThePreviousStep)):
            state.signUp = nil
            state.signIn = .init()
            return .none
            
        case .signUp(.delegate(.goBackToLoginView)):
            state.signUp = nil
            return .run { send in
                await send(.internal(.goBackToLoginView))
            }
        case .delegate(_):
            return  .none
        case .internal(_):
            return  .none
        case .signIn(_):
            return .none
        case .signUp(.internal(_)):
            return .none
        case .userLocalSettings(_):
            return .none
        case .termsAndConditions(_):
            return .none
        }
    }
}

public extension Onboarding {
    func signIn(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .signIn(.delegate(.userPressedSignUp)):
            state.signIn = nil
            state.signUp = .init()
            return .none
            
        case let .signIn(.delegate(.userLoggedIn(jwt: jwt))):
            return .run { send in
                await send(.delegate(.userLoggedIn(jwt: jwt)))
            }
        case .delegate(_):
            return  .none
        case .internal(_):
            return  .none
        case .signIn(.internal(_)):
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

public extension Onboarding {
    func termsAndConditions(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case let .termsAndConditions(.delegate(.previousStep(user))):
            state.termsAndConditions = nil
            state.userLocalSettings = .init(user: user)
            return .none
            
        case .termsAndConditions(.delegate(.goBackToLoginView)):
            state.termsAndConditions = nil
            return .run { send in
                await send(.internal(.goBackToLoginView))
            }
        case let .termsAndConditions(.delegate(.userFinishedOnboarding(jwt))):
            return .run { send in
                await send(.delegate(.userFinishedOnboarding(jwt: jwt)))
            }
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
        case .termsAndConditions(.internal(_)):
            return .none
        }
    }
}

public extension Onboarding {
    func `internal`(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .internal(.goBackToLoginView):
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

public extension Onboarding {
    func userLocalSettings(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .userLocalSettings(.delegate(.goBackToLoginView)):
            state.userLocalSettings = nil
            return .run { send in
                await send(.internal(.goBackToLoginView))
            }
            
        case let .userLocalSettings(.delegate(.nextStep(user))):
            state.userLocalSettings = nil
            state.termsAndConditions = .init(user: user)
            return .none
            
        case let .userLocalSettings(.delegate(.previousStep(user))):
            state.userLocalSettings = nil
            state.signUp = .init(user: user, email: user.credentials.email, password: user.credentials.password)
            return .none
        case .delegate(_):
            return  .none
        case .internal(_):
            return  .none
        case .signIn(_):
            return .none
        case .signUp(_):
            return .none
        case .userLocalSettings(.internal(_)):
            return .none
        case .termsAndConditions(_):
            return .none
        }
    }
}
