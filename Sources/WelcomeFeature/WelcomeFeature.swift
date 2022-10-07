import Foundation
import ComposableArchitecture
import UserModel


///Conforming AlertState to Sendable
extension AlertState: @unchecked Sendable {}

public struct Welcome: ReducerProtocol {
    
    public init() {}
}

public extension Welcome {
    
    struct State: Equatable, Sendable {
        public var user: User?
        public var alert: AlertState<Action>?
        public var email: String
        public var password: String
        
        ///Rudimentary check to see if password exceeds 5 charachters. Will be replace by more sofisticated check later on.
        public var passwordFulfillsRequirements: Bool {
            if password.count > 5 {
                return true
            }
            return false
        }
        ///Check to see if email exceeds 5 charachters and if it contains `@`. Willl be replaced by RegEx.
        public var emailFulfillsRequirements: Bool {
            guard email.count > 5 else {
                return false
            }
            
            guard email.contains("@") else {
                return false
            }
            return true
        }
        
        ///If either of the 3 conditions are `false` we return `true` and can disable specific buttons.
        public var disableButton: Bool {
            if !passwordFulfillsRequirements || !emailFulfillsRequirements {
                return true
            } else {
                return false
            }
        }
        
        public init(
            user: User? = nil,
            alert: AlertState<Action>? = nil,
            email: String = "tatatta@",
            password: String = "tatatat"
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
            case nextStep
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case goToNextStep(User)
            case goToThePreviousStep
            case goBackToLoginView
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
                
            case .internal(.nextStep):
                print("test")
                state.user = User(email: state.email, password: state.password, jwt: "")
//                guard let user = state.user else {
//                    state.alert = AlertState(
//                        title: TextState("Error"),
//                        message: TextState("Please enter your information"),
//                        dismissButton: .cancel(TextState("Dismiss"), action: .none)
//                    )
//                    return .none
//                }
                return .run { [user = state.user] send in
                    await send(.delegate(.goToNextStep(user!)))
                }
                
            case .delegate(_):
                return .none
            case .internal(_):
                return .none
            }
        }
    }
}

