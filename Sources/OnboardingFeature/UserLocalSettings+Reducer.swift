import ComposableArchitecture
import Foundation

public extension Onboarding {
    
    func userLocalSettings(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case .route(.userLocalSettings(.delegate(.goBackToSignInView))):
            return .run { send in
                await send(.internal(.goBackToSignInViewTapped))
            }
            
        case let .route(.userLocalSettings(.delegate(.nextStep(user)))):
            state.route = .termsAndConditions(.init(user: user))
            return .none
            
        case let .route(.userLocalSettings(.delegate(.previousStep(user)))):
            
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
