import Foundation
import SwiftUI
import ComposableArchitecture
import UserModel
import UserDefaultsClient
import ApiClient
import SiteRouter

public struct TermsAndConditions: ReducerProtocol, Sendable {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
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
            case alertConfirmTapped
            case finishSignUpButtonTapped
            case termsAndConditionsBoxTapped
            case createUserResponse(TaskResult<JWT>)
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case userFinishedOnboarding(JWT)
            case previousStepTapped(delegating: User)
            case goBackToSignInViewTapped
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case .internal(.termsAndConditionsBoxTapped):
                state.areTermsAndConditionsAccepted.toggle()
                return .none
                
            case .internal(.alertConfirmTapped):
                state.alert = nil
                return .none
                
            case .internal(.finishSignUpButtonTapped):
                return .run { [user = state.user] send in
                    
                     await send(.internal(
                        .createUserResponse(
                            TaskResult {
                                try await self.apiClient.decodedResponse(
                                    for: .users(.create(user)),
                                    as: ResultPayload<JWT>.self
                                ).value.status.get()
                            }
                        )
                    ))
                }
                
            case let .internal(.createUserResponse(.success(jwt))):
                return .run {  send in
                    await self.userDefaultsClient.setLoggedInUserJWT(jwt)
                    await send(.delegate(.userFinishedOnboarding(jwt)), animation: .default)
                }
                
            case let .internal(.createUserResponse(.failure(error))):
                state.alert = AlertState(
                    title: TextState("Error"),
                    message: TextState(error.localizedDescription),
                    dismissButton: .cancel(TextState("Dismiss"), action: .none)
                )
                return .none
                
            case .internal, .delegate:
                return .none
            }
        }
    }
}

extension Animation: @unchecked Sendable {}
extension AlertState: @unchecked Sendable {}
