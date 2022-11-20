import ComposableArchitecture
import Foundation

public extension Onboarding {
    func userLocalSettings(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .userLocalSettings(.delegate(.goBackToLoginView)):
            state.userLocalSettings = nil
            return .run { send in
                await send(.internal(.goBackToLoginViewTapped))
            }
            
        case let .userLocalSettings(.delegate(.nextStep(user))):
            state.userLocalSettings = nil
            state.termsAndConditions = .init(user: user)
            return .none
            
        case let .userLocalSettings(.delegate(.previousStep(user))):
            state.userLocalSettings = nil
            state.signUp = .init(user: user, email: user.credentials.email, password: user.credentials.password)
            return .none
        case .delegate(_):
            return  .none
        case .internal(_):
            return  .none
        case .signIn(_):
            return .none
        case .signUp(_):
            return .none
        case .userLocalSettings(.internal(_)):
            return .none
        case .termsAndConditions(_):
            return .none
        }
    }
}
