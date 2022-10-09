//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import SplashFeature
import OnboardingFeature
import MainFeature
import UserDefaultsClient
import URLRoutingClient
import UserModel

public struct App: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.urlRoutingClient) var urlRoutingClient
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
        case splash(Splash.Action)
        case onboarding(Onboarding.Action)
        case main(Main.Action)
        case `internal`(InternalAction)
        
        
        public enum InternalAction: Equatable, Sendable {
            case userIsLoggedIn(JWT)
        }
    }
    
    
    var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
                
                /// If user is logged in we receive action from splash delegate and then send action to userDefaults to get the logged in user's JWT.
            case let .splash(.delegate(.loadIsLoggedInResult(jwt))):
                guard let jwt else {
                    state = .onboarding(.init(signIn: .init(), step: .step0_SignIn))
                    return .none
                }
                
                return .run { send in
                    await send(
                        .internal(.userIsLoggedIn(jwt)
                                 )
                    )
                }
                
                /// When we're retrieved the JWT we will change state to `main` and send the JWT through.
            case let .internal(.userIsLoggedIn(jwt)):
                state = .main(.init(jwt: jwt))
                return .none
                
                ///When a user logs out from `main` we initialize onboarding again.
            case .main(.delegate(.userIsLoggedOut)):
                state = .onboarding(.init(signIn: .init(), step: .step0_SignIn))
                return .none
                
                ///After a user have finished onboarding and received the jwt we will send them through to `main`
            case let .onboarding(.delegate(.userFinishedOnboarding(jwt))):
                state = .main(.init(jwt: jwt))
                return .none
               
                ///When a user logs in through onboarding we change state to `main` and send their jwt through.
            case let .onboarding(.delegate(.userLoggedIn(jwt))):
                state = .main(.init(jwt: jwt))
                return .none
                
            case .splash(.internal(_)):
                return .none
                
            case .onboarding(.internal(_)):
                return .none
                
            case .main(.internal(_)):
                return .none
                
            case .internal(_):
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


public extension App {
    struct View: SwiftUI.View {
        let store: StoreOf<App>
        
        public init(store: StoreOf<App>) {
            self.store = store
        }
        ///Scoping the correct store depending on the state
        public var body: some SwiftUI.View {
            IfLetStore(self.store.scope(
                state: /App.State.splash,
                action: App.Action.splash),
                       then:Splash.View.init(store:)
            )
            IfLetStore(self.store.scope(
                state: /App.State.onboarding,
                action: App.Action.onboarding),
                       then:Onboarding.View.init(store:)
            )
            IfLetStore(self.store.scope(
                state: /App.State.main,
                action: App.Action.main),
                       then:Main.View.init(store:)
            )
            
        }
    }
}
