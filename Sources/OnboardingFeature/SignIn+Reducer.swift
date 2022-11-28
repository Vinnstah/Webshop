import ComposableArchitecture
import SwiftUI
import SignInFeature
import Foundation
import UserModel

public extension Onboarding {
    
    func signIn(
        into state: inout State,
        action: Action
    ) -> Effect<Action, Never> {
        
        switch action {
            
        case .route(.signIn(.delegate(.userPressedSignUp))):
            state.route = .signUp(.init(user: User(credentials: User.Credentials(email: "", password: ""))))
            return .none
            
        case let .route(.signIn(.delegate(.userLoggedIn(with: jwt)))):
            return .run { send in
                await send(.delegate(.userLoggedIn(with: jwt)), animation: .easeIn)
            }
            
        case .delegate, .route, .internal:
            return .none
        }
    }
}

extension Animation : @unchecked Sendable {}
