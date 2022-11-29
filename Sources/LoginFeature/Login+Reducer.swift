import ComposableArchitecture
import Foundation
import UserModel
import SiteRouter

public extension Login {
    func login(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .login(.loginButtonTapped):
            state.isLoginInFlight = true
            
            state.user = User(
                credentials: .init(
                    email: state.email,
                    password: state.password
                )
            )
            
            return .run { [user = state.user] send in
                guard let user else {
                    return await send(
                        .login(
                            .loginResponse(
                                .failure(ClientError.failedToLogin("No user found")))))
                }
                
                return await send(
                    .login(
                        .loginResponse(
                    TaskResult {
                        try await self.apiClient.decodedResponse(
                            for: .users(.login(user)),
                            as: ResultPayload<JWT>.self
                        ).value.status.get()
                    }
                )))
            }
            
            /// If login is successful we set `loginInFlight` to `false`. We then set userDefaults `isLoggedIn` to `true` and add the user JWT.
        case let .login(.loginResponse(.success(jwt))):
            state.isLoginInFlight = false
            
            return .run { send in
                /// Set `LoggedInUserJWT` in `userDefaults` to the `jwt` we received back from the server
                await self.userDefaultsClient.setLoggedInUserJWT(jwt)
                /// Delegate the action `userLoggedIn` with the given `jwt`
                await send(.delegate(.userLoggedIn(with: jwt)))
            }
            
            /// If login fails we show an alert.
        case let .login(.loginResponse(.failure(error))):
            
            state.isLoginInFlight = false
            
            state.alert = AlertState(
                title: TextState("Error"),
                message: TextState(error.localizedDescription),
                dismissButton: .cancel(TextState("Dismiss"), action: .none)
            )
            return .none
            
        case .delegate, .internal:
            return .none
        }
    }
}
