import Foundation
import ComposableArchitecture

public extension Onboarding {
    func `internal`(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case .internal(.goBackToSignInViewTapped):
            state.signIn = .init()
            return .none
            
        case .internal(.alertConfirmTapped):
            state.alert = nil
            return .none
            
        case .delegate(_):
            return  .none
        case .internal(_):
            return  .none
        case .signIn(_):
            return .none
        case .signUp(_):
            return .none
        case .userLocalSettings(_):
            return .none
        case .termsAndConditions(_):
            return .none
        }
    }
}
