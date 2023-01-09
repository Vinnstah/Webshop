import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel
import SignUpFeature
import UserLocalSettingsFeature
import TermsAndConditionsFeature
import LoginFeature

public struct Onboarding: ReducerProtocol {
    public init() {}
}

public extension Onboarding {
    struct State: Equatable, Sendable {
        
        var route: Route?
        
        public init(route: Route? = .login(Login.State())) {
            self.route = route
        }
        
        public enum Route: Equatable, Sendable {
            case login(Login.State)
            case signUp(SignUp.State)
            case userLocalSettings(UserLocalSettings.State)
            case termsAndConditions(TermsAndConditions.State)
        }
    }
    
    typealias JWT = String
    
    enum Action: Equatable, Sendable {
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        
        case route(Route)
        
        public enum Route: Equatable, Sendable{
            case login(Login.Action)
            case signUp(SignUp.Action)
            case userLocalSettings(UserLocalSettings.Action)
            case termsAndConditions(TermsAndConditions.Action)
        }
        
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
            Reduce(self.login)
            Reduce(self.signUp)
            Reduce(self.userLocalSettings)
            Reduce(self.termsAndConditions)
            
        }
        .ifLet(\.route, action: /Action.route) {
            EmptyReducer()
            .ifCaseLet(/State.Route.login, action: /Action.Route.login) {
                Login()
            }
            .ifCaseLet(/State.Route.signUp, action: /Action.Route.signUp) {
                SignUp()
            }
            .ifCaseLet(/State.Route.userLocalSettings, action: /Action.Route.userLocalSettings) {
                UserLocalSettings()
            }
            .ifCaseLet(/State.Route.termsAndConditions, action: /Action.Route.termsAndConditions) {
                TermsAndConditions()
            }
        }
    }
}
