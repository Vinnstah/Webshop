import ComposableArchitecture
import Foundation

public extension Onboarding {
    func signUp(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case let .signUp(.delegate(.goToNextStep(user))):
            state.signUp = nil
            state.userLocalSettings = .init(user: user)
            return .none
            
        case .signUp(.delegate(.goToThePreviousStep)):
            state.signUp = nil
            state.signIn = .init()
            return .none
            
        case .signUp(.delegate(.goBackToLoginView)):
            state.signUp = nil
            return .run { send in
                await send(.internal(.goBackToLoginViewTapped))
            }
        case .delegate(_):
            return  .none
        case .internal(_):
            return  .none
        case .signIn(_):
            return .none
        case .signUp(.internal(_)):
            return .none
        case .userLocalSettings(_):
            return .none
        case .termsAndConditions(_):
            return .none
        }
    }
}
