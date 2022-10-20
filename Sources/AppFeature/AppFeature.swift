import Foundation
import SwiftUI
import ComposableArchitecture
import SplashFeature
import OnboardingFeature
import MainFeature
import UserModel

public struct App: ReducerProtocol {
    public init() {}
}

public extension App {
    
    typealias JWT = String
    
    enum State: Equatable {
        case splash(Splash.State)
        case onboarding(Onboarding.State)
        case main(Main.State)
        
        public init() {
            self = .splash(.init())
        }
    }
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case splash(Splash.Action)
        case onboarding(Onboarding.Action)
        case main(Main.Action)
        
        
        public enum InternalAction: Equatable, Sendable {
            case userIsLoggedIn
        }
    }
    
    
    var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
                
                /// If user is logged in we receive action from splash delegate and then send action to userDefaults to get the logged in user's JWT.
            case let .splash(.delegate(.loadIsLoggedInResult(jwt))):
                guard let jwt else {
                    state = .onboarding(.init(signIn: .init()))
                    return .none
                }
                
                return .run { send in
                    await send(
                        .internal(.userIsLoggedIn
                                 )
                    )
                }
                
                /// When we're retrieved the JWT we will change state to `main` and send the JWT through.
            case .internal(.userIsLoggedIn):
                state = .main(.init())
                return .none
                
                ///When a user logs out from `main` we initialize onboarding again.
            case .main((.delegate(.userIsLoggedOut))):
                state = .onboarding(.init(signIn: .init()))
                return .none
                
                ///After a user have finished onboarding and received the jwt we will send them through to `main`
            case let .onboarding(.delegate(.userFinishedOnboarding(jwt))):
                state = .main(.init())
                return .none
               
                ///When a user logs in through onboarding we change state to `main` and send their jwt through.
            case .onboarding(.delegate(.userLoggedIn)):
                state = .main(.init())
                return .none
                
            case .splash(.internal(_)):
                return .none
                
            case .onboarding(.internal(_)):
                return .none
                
            case .main(.internal(_)):
                return .none
                
            case .internal(_):
                return .none
//
            case .onboarding(.signIn(_)):
                return .none
            case .onboarding(.signUp(_)):
                return .none
            case .onboarding(.userLocalSettings(_)):
                return .none
            case .onboarding(.termsAndConditions(_)):
                return .none
            case .main(.home(.internal(_))):
                return .none
            case .main(.home(.delegate(_))):
                return .none
            case .main(.products(_)):
                return .none
            }
        }
        ///Changing View depending on which state is initialized.
        .ifCaseLet(
            /State.splash,
             action: /Action.splash
        ) {
            Splash()
        }
        .ifCaseLet(
            /State.onboarding,
             action: /Action.onboarding
        ) {
            Onboarding()
        }
        .ifCaseLet(
            /State.main,
             action: /Action.main
        ) {
            Main()
        }
        
    }
}
