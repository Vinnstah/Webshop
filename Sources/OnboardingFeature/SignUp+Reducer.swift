import ComposableArchitecture
import SignUpFeature
import Foundation

public extension Onboarding {
    
    func signUp(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case let .route(.signUp(.delegate(.goToNextStep(user)))):
            state.route = .userLocalSettings(.init(user: user))
            return .none
            
        case .route(.signUp(.delegate(.goToThePreviousStep))):
            state.route = .login(.init())
            return .none
            
        case .route(.signUp(.delegate(.goBackToSignInView))):
            return .run { send in
                await send(.internal(.goBackToSignInViewTapped))
            }
            
        case .delegate, .route, .internal:
            return .none
        }
    }
}
