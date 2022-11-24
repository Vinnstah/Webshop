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
            case signInUser
        }
    }
    
    
    var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
                
            case let .splash(.delegate(.loadIsLoggedInResult(jwt))):
                guard jwt != nil else {
                    state = .onboarding(.init(signIn: .init()))
                    return .none
                }
                
                return .run { send in
                    await send(
                        .internal(.signInUser)
                    )
                }
                
                /// When we're retrieved the JWT we will change state to `main` and send the JWT through.
            case .internal(.signInUser):
                state = .main(.init())
                return .none
                 
                ///When a user logs out from `main` we initialize onboarding again.
            case .main((.delegate(.userIsSignedOut))):
                state = .onboarding(.init(signIn: .init()))
                return .none
                
                ///After a user have finished onboarding and received the jwt we will send them through to `main`
            case .onboarding(.delegate(.userFinishedOnboarding)):
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
            case .main(.favorites(_)):
                return .none
            case .main(.checkout(_)):
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
