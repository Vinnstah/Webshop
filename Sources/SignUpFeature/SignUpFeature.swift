import Foundation
import ComposableArchitecture
import UserModel


///Conforming AlertState to Sendable
extension AlertState: @unchecked Sendable {}

public struct SignUp: ReducerProtocol {
    
    public init() {}
}

public extension SignUp {
    
    struct State: Equatable, Sendable {
        public var alert: AlertState<Action>?
        public var email: String
        public var password: String
        public var user: User
        
        public var passwordFulfillsRequirements: PasswordChecker {
            checkIfPasswordFulfillsRequirements(password)
        }
        
        public var emailFulfillsRequirements: EmailCheckerResult {
            checkIfEmailFullfillRequirements(email)
        }
        
        public var disableButton: Bool {
            passwordFulfillsRequirements != .valid || emailFulfillsRequirements != .valid
        }
        
        public init(
            user: User,
            alert: AlertState<Action>? = nil,
            email: String = "",
            password: String = ""
        ) {
            self.user = user
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
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case goToNextStepTapped(delegating: User)
            case goToThePreviousStepTapped
            case goBackToSignInViewTapped
        }
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                ///Set `email` when emailField recceives input
            case let .internal(.emailAddressFieldReceivingInput(text: text)):
                state.email = text
                state.user.credentials.email = state.email
                return .none
                
                ///Set  `password` when passwordField receives input.
            case let .internal(.passwordFieldReceivingInput(text: text)):
                state.password = text
                state.user.credentials.password = state.password
                return .none
                
            case .delegate, .internal:
                return .none
            }
        }
    }
}

