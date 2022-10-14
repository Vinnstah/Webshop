import Foundation
import ComposableArchitecture
import SwiftUI
import HomeFeature

public struct Main: ReducerProtocol {
    public init() {}
}

public extension Main {
    struct State: Equatable, Sendable {
        
        public var selectedTab: Tab
        public var home: Home.State
        
        public init(
            selectedTab: Tab = .home,
            home: Home.State = .init()
        ) {
            
            self.selectedTab = selectedTab
            self.home = home
        }
        
        public enum Tab: Equatable, Sendable {
            case home
            case products
            case settings
            case checkout
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        case home(Home.Action)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsLoggedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case tabSelected
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .home(.delegate(.userIsLoggedOut)):
                return .run { send in
                    await send(.delegate(.userIsLoggedOut))
                }
            case .delegate(_):
                return .none
            case .home(_):
                return .none
            case .internal(_):
                return .none
            }
        }
    }
    
}



