import ComposableArchitecture
import Foundation

public extension Onboarding {
    
    func signUp(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case let .signUp(.delegate(.goToNextStep(user))):
            state.signUp = nil
            state.userLocalSettings = .init(user: user)
            return .none
            
        case .signUp(.delegate(.goToThePreviousStep)):
            state.signUp = nil
            state.signIn = .init()
            return .none
            
        case .signUp(.delegate(.goBackToSignInView)):
            state.signUp = nil
            return .run { send in
                await send(.internal(.goBackToSignInViewTapped))
            }
            
        default:
            return .none
        }
    }
}
