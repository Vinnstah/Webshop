import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel

extension AlertState: @unchecked Sendable {}

public struct UserLocalSettings: ReducerProtocol {
    public init() {}
}

public extension UserLocalSettings {
    
    struct State: Equatable, Sendable {
        public var alert: AlertState<Action>?
        public var user: User
        
        
        public init(
            alert: AlertState<Action>? = nil,
            user: User
        ) {
            self.alert = alert
            self.user = user
        }
    }
    
    enum Action: Equatable, Sendable {
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        
        public enum InternalAction: Equatable, Sendable {
            case nextStep
            case previousStep
            case cancelButtonPressed
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case nextStep(User)
            case previousStep(User)
            case goBackToSignInView
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case .internal(.nextStep):
                return .run { [user = state.user] send in
                    await send(.delegate(.nextStep(user)))
                }
                
            case .internal(.previousStep):
                return .run { [user = state.user] send in
                    await send(.delegate(.previousStep(user)))
                }
            
            case .internal(.cancelButtonPressed):
                return .run { send in
                    await send(.delegate(.goBackToSignInView))
                }

            case .internal(.alertConfirmTapped):
                state.alert = nil
                return .none
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
                
            }
        }
    }
}
