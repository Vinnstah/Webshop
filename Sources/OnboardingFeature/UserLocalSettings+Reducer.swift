import ComposableArchitecture
import Foundation

public extension Onboarding {
    
    func userLocalSettings(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case .route(.userLocalSettings(.delegate(.goBackToSignInViewTapped))):
            return .run { send in
                await send(.internal(.goBackToSignInViewTapped))
            }
            
        case let .route(.userLocalSettings(.delegate(.nextStepTapped(delegating: user)))):
            state.route = .termsAndConditions(.init(user: user))
            return .none
            
        case let .route(.userLocalSettings(.delegate(.previousStepTapped(delegating: user)))):
            
            state.route = .signUp(.init(
                user: user,
                email: user.credentials.email,
                password: user.credentials.password
            ))
            return .none
            
        case .delegate, .route, .internal:
            return .none
        }
    }
}
