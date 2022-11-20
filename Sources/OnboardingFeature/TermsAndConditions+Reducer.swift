import ComposableArchitecture
import Foundation

public extension Onboarding {
    func termsAndConditions(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case let .termsAndConditions(.delegate(.previousStep(user))):
            state.termsAndConditions = nil
            state.userLocalSettings = .init(user: user)
            return .none
            
        case .termsAndConditions(.delegate(.goBackToLoginView)):
            state.termsAndConditions = nil
            return .run { send in
                await send(.internal(.goBackToLoginViewTapped))
            }
        case let .termsAndConditions(.delegate(.userFinishedOnboarding(jwt))):
            return .run { send in
                await send(.delegate(.userFinishedOnboarding(jwt: jwt)))
            }
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
        case .termsAndConditions(.internal(_)):
            return .none
        }
    }
}
