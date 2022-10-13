import Foundation
import ComposableArchitecture
import UserModel
import UserDefaultsClient
import ApiClient
import SiteRouter

extension AlertState: @unchecked Sendable {}
public struct TermsAndConditions: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.apiClient) var apiClient
    public init() {}
}


public extension TermsAndConditions {
    typealias JWT = String
    struct State: Equatable, Sendable {
        public var areTermsAndConditionsAccepted: Bool
        public var alert: AlertState<Action>?
        public var user: User
        
        
        public init(
            areTermsAndConditionsAccepted: Bool = false,
            alert: AlertState<Action>? = nil,
            user: User
        ) {
            self.areTermsAndConditionsAccepted = areTermsAndConditionsAccepted
            self.alert = alert
            self.user = user
        }
    }
    
    enum Action: Equatable, Sendable {
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        
        public enum InternalAction: Equatable, Sendable {
            case nextStep
            case previousStep
            case cancelButtonPressed
            case alertConfirmTapped
            case finishSignUpButtonPressed
            case termsAndConditionsBoxPressed
            case finishSignUp
            case createUserRequest(User)
            case createUserResponse(TaskResult<JWT>)
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(JWT)
            case previousStep(User)
            case goBackToLoginView
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case .internal(.finishSignUpButtonPressed):
                return .run { send in
                    await send(.internal(.finishSignUp))
                }
                
            case .internal(.previousStep):
                return .run { [user = state.user] send in
                    await send(.delegate(.previousStep(user)))
                }
                
            case .internal(.cancelButtonPressed):
                return .run { send in
                    await send(.delegate(.goBackToLoginView))
                }
                
            case .internal(.termsAndConditionsBoxPressed):
                state.areTermsAndConditionsAccepted.toggle()
                return .none
                
            case .internal(.alertConfirmTapped):
                state.alert = nil
                return .none
                
            case .internal(.finishSignUp):
                return .run { [
                    user = state.user
                ] send in
                    
                    await send(.internal(.createUserRequest(user)))
                }
                
            case let .internal(.createUserRequest(user)):
                
                return .run { [apiClient] send in
                    return await send(.internal(
                        .createUserResponse(
                            TaskResult {
                                try await apiClient.decodedResponse(
                                    for: .create(user),
                                    as: ResultPayload<JWT>.self
                                ).value.status.get()
                            }
                        )
                    )
                    )
                    
                }
                
            case let .internal(.createUserResponse(.success(jwt))):
                return .run { [mainQueue, userDefaultsClient] send in
                    try await mainQueue.sleep(for: .milliseconds(700))
                    await userDefaultsClient.setLoggedInUserJWT(jwt)
                    await send(.delegate(.userFinishedOnboarding(jwt)))
                }
                
            case let .internal(.createUserResponse(.failure(error))):
                state.alert = AlertState(
                    title: TextState("Error"),
                    message: TextState(error.localizedDescription),
                    dismissButton: .cancel(TextState("Dismiss"), action: .none)
                )
                return .none
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
                
                
            }
        }
    }
}
