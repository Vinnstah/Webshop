import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel
import Boardgame

extension AlertState: @unchecked Sendable {}

public struct UserLocalSettings: ReducerProtocol {
    public init() {}
}

public extension UserLocalSettings {
    
    struct State: Equatable, Sendable {
        public var alert: AlertState<Action>?
        public var user: User
        public var categories: IdentifiedArrayOf<Boardgame.Category>
        
        
        public init(
            alert: AlertState<Action>? = nil,
            user: User,
            categories: IdentifiedArrayOf<Boardgame.Category> = IdentifiedArray(uniqueElements: Boardgame.Category.allCases)
            
        ) {
            self.alert = alert
            self.user = user
            self.categories = categories
        }
        
    }
    enum Action: Equatable, Sendable {
        
        case delegate(DelegateAction)
        case `internal`(InternalAction)
        
        public enum InternalAction: Equatable, Sendable {
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case nextStepTapped(delegating: User)
            case previousStepTapped(delegating: User)
            case goBackToSignInViewTapped
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
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
