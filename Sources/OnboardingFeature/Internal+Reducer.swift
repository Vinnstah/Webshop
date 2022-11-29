import Foundation
import ComposableArchitecture

public extension Onboarding {
    func `internal`(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case .internal(.goBackToSignInViewTapped):
            state.route = .login(.init())
            return .none
            
        case .delegate, .route, .internal:
            return .none
        }
    }
}
