import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient
import SiteRouter
import URLRouting
import ApiClient
import UserModel

///Conforming AlertState to Sendable
extension AlertState: @unchecked Sendable {}


public struct SignIn: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.apiClient) var apiClient
    
    public init() {}
}

public extension SignIn {
    
    struct State: Equatable, Sendable {
        public var user: User?
        public var isLoginInFlight: Bool
        public var alert: AlertState<Action>?
        public var email: String
        public var password: String
        
        ///Rudimentary check to see if password exceeds 5 charachters. Will be replace by more sofisticated check later on.
        public var passwordFulfillsRequirements: Bool {
            password.count > 5
        }
        ///Check to see if email exceeds 5 charachters and if it contains `@`. Willl be replaced by RegEx.
        public var emailFulfillsRequirements: Bool {
            email.count > 5 && email.contains("@")
        }
        
        ///If either of the 3 conditions are `false` we return `true` and can disable specific buttons.
        public var disableButton: Bool {
             !passwordFulfillsRequirements || !emailFulfillsRequirements || isLoginInFlight
        }
        
        public init(
            user: User? = nil,
            isLoginInFlight: Bool = false,
            alert: AlertState<Action>? = nil,
            email: String = "",
            password: String = ""
        ) {
            self.user = user
            self.isLoginInFlight = isLoginInFlight
            self.alert = alert
            self.email = email
            self.password = password
        }
    }
    
    typealias JWT = String
    
    enum Action: Equatable, Sendable {
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        
        public enum InternalAction: Equatable, Sendable {
            case emailAddressFieldReceivingInput(text: String)
            case passwordFieldReceivingInput(text: String)
            case loginButtonPressed
            case loginResponse(TaskResult<JWT>)
            case signUpButtonPressed
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userLoggedIn(jwt: JWT)
            case userPressedSignUp
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
                ///Set `email` when emailField recceives input
            case let .internal(.emailAddressFieldReceivingInput(text: text)):
                state.email = text
                return .none
                
                ///Set  `password` when passwordField receives input.
            case let .internal(.passwordFieldReceivingInput(text: text)):
                state.password = text
                return .none
                
                /// When loginButton is pressed set `loginInFlight` to `true`. Send a api request to login endpoint with `state.user` and receive the TaskResult back.
            case .internal(.loginButtonPressed):
                state.isLoginInFlight = true
                state.user = User(email: state.email, password: state.password, jwt: "")
                
                return .run { [apiClient, user = state.user] send in
                    guard let user else {
                        return await send(
                            .internal(
                                .loginResponse(
                                    .failure(ClientError.failedToLogin("No user found")))))
                    }
                    return await send(.internal(.loginResponse(
                        TaskResult {
                            try await apiClient.decodedResponse(
                                for: .login(user),
                                as: ResultPayload<JWT>.self
                            ).value.status.get()
                        }
                    )))
                }
                
                /// If login is successful we set `loginInFlight` to `false`. We then set userDefaults `isLoggedIn` to `true` and add the user JWT.
            case let .internal(.loginResponse(.success(jwt))):
                state.isLoginInFlight = false
                
                return .run { [userDefaultsClient] send in
                    /// Set `LoggedInUserJWT` in `userDefaults` to the `jwt` we received back from the server
                    await userDefaultsClient.setLoggedInUserJWT(jwt)
                    /// Delegate the action `userLoggedIn` with the given `jwt`
                    await send(.delegate(.userLoggedIn(jwt: jwt)))
                }
                
                /// If login fails we show an alert.
            case let .internal(.loginResponse(.failure(error))):
                state.isLoginInFlight = false
                state.alert = AlertState(
                    title: TextState("Error"),
                    message: TextState(error.localizedDescription),
                    dismissButton: .cancel(TextState("Dismiss"), action: .none)
                )
                return .none
                
                /// We move to the Welcome step when `signUpButton` is pressed
            case .internal(.signUpButtonPressed):
                return .run { send in
                    await send(.delegate(.userPressedSignUp))
                }
                
                
                /// When the user clicks confirm on the alert we set the `state.alert` to `nil` to remove the alert
            case .internal(.alertConfirmTapped):
                state.alert = nil
                return .none
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
            }
        }
    }
}
    
    
