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

public struct App: ReducerProtocol {
    public init() {}
}

public extension App {
    enum State: Equatable {
        case splash(Splash.State)
        public init() { self = .splash(.init())}
    }
    enum Action: Equatable {
        case splash(Splash.Action)
    }
    
    
    var body: some ReducerProtocol<State, Action> {

        Reduce { state, action in
            switch action {
                
            case .splash(.delegate(.loadIsLoggedInResult(.isLoggedIn))):
                return .none
                
            case .splash(.delegate(.loadIsLoggedInResult(.notLoggedIn))):
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
    }
}


public extension App {
    struct View: SwiftUI.View {
        let store: StoreOf<App>
        
        public init(store: StoreOf<App>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            SwitchStore(self.store) {
                CaseLet(
                    state: /App.State.splash,
                    action: App.Action.splash,
                    then: Splash.View.init
                )
            }
        }
        
    }
}
