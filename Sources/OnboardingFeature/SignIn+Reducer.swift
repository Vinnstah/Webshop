import ComposableArchitecture
import Foundation

public extension Onboarding {
    
    func signIn(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case .signIn(.delegate(.userPressedSignUp)):
            state.signIn = nil
            state.signUp = .init()
            return .none
            
        case let .signIn(.delegate(.userLoggedIn(with: jwt))):
            return .run { send in
                await send(.delegate(.userLoggedIn(with: jwt)))
            }
            
        default:
            return .none
        }
    }
}
