import ComposableArchitecture
import SwiftUI
import LoginFeature
import Foundation
import UserModel

public extension Onboarding {
    
    func login(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case .route(.login(.delegate(.signUpButtonTapped))):
            state.route = .signUp(.init(user: User(credentials: User.Credentials(email: "", password: ""))))
            return .none
            
        case let .route(.login(.delegate(.userLoggedIn(with: jwt)))):
            return .run { send in
                await send(.delegate(.userLoggedIn(with: jwt)), animation: .easeIn)
            }
            
        case .delegate, .route, .internal:
            return .none
        }
    }
}

extension Animation : @unchecked Sendable {}
