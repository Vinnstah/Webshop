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

public struct App: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    public init() {}
}

public extension App {
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
        case userIsLoggedIn(DefaultCurrency)
    }
    
    
    var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
                
            case .splash(.delegate(.loadIsLoggedInResult(.isLoggedIn))):
                return .run { [userDefaultsClient] send in
                    await send(
                        .userIsLoggedIn(
                            .init(userDefaultsClient.getDefaultCurrency())
                        )
                    )
                }
//
            case let .userIsLoggedIn(currency):
                state = .main(.init(defaultCurrency: currency.rawValue, token: "IMPLEMENT THIS"))
                return .none
                
            case .splash(.delegate(.loadIsLoggedInResult(.notLoggedIn))):
                state = .onboarding(.init(step: .step0_LoginOrCreateUser))
                return .none
                
            case .main(.delegate(.userIsLoggedOut)):
                state = .onboarding(.init(step: .step0_LoginOrCreateUser))
                return .none
                
            case let .onboarding(.delegate(.userFinishedOnboarding(currency, token))):
                state = .main(.init(defaultCurrency: currency.rawValue, token: token))
                return .none
                
            default: return .none
            }
        }
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

