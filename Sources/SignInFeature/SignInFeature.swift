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

public struct SignIn: ReducerProtocol, Sendable {
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
        
        public var disableButton: Bool {
            checkIfPasswordFulfillsRequirements(password) != .valid ||
            checkIfEmailFullfillRequirements(email) != .valid ||
            isLoginInFlight
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
        case login(LoginAction)
        
        public enum InternalAction: Equatable, Sendable {
            case emailAddressFieldReceivingInput(text: String)
            case passwordFieldReceivingInput(text: String)
            case signUpButtonTapped
            case alertConfirmTapped
        }
        
        public enum LoginAction: Equatable, Sendable {
            case loginButtonTapped
            case loginResponse(TaskResult<JWT>)
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userLoggedIn(with: JWT)
            case signUpButtonTapped
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        CombineReducers {
            
            Reduce(self.login)
            
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
                    /// We move to the Welcome step when `signUpButton` is pressed
                case .internal(.signUpButtonTapped):
                    return .run { send in
                        await send(.delegate(.signUpButtonTapped))
                    }
                    
                    /// When the user clicks confirm on the alert we set the `state.alert` to `nil` to remove the alert
                case .internal(.alertConfirmTapped):
                    state.alert = nil
                    return .none
                    
                case .login, .internal, .delegate:
                    return .none
                    
                }
            }
        }
    }
}
