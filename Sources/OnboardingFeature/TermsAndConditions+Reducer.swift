import ComposableArchitecture
import Foundation

public extension Onboarding {
    
    func termsAndConditions(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case let .route(.termsAndConditions(.delegate(.previousStep(user)))):
            state.route = .userLocalSettings(.init(user: user))
            return .none
            
        case .route(.termsAndConditions(.delegate(.goBackToSignInView))):
            return .run { send in
                await send(.internal(.goBackToSignInViewTapped))
            }
            
        case let .route(.termsAndConditions(.delegate(.userFinishedOnboarding(jwt)))):
            return .run { send in
                await send(.delegate(.userFinishedOnboarding(with: jwt)))
            }
            
        case .delegate, .route, .internal:
            return .none
        }
    }
}
