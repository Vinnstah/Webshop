//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-10-07.
//

import Foundation
import ComposableArchitecture

extension AlertState: @unchecked Sendable {}
public struct TermsAndConditions: ReducerProtocol {
    public init() {}
}


public extension TermsAndConditions {
    
    struct State: Equatable, Sendable {
        public var areTermsAndConditionsAccepted: Bool
        public var alert: AlertState<Action>?
        
        
        public init(
            areTermsAndConditionsAccepted: Bool = false,
            alert: AlertState<Action>? = nil
        ) {
            self.areTermsAndConditionsAccepted = areTermsAndConditionsAccepted
            self.alert = alert
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
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case finishSignUp
            case previousStep
            case goBackToLoginView
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case .internal(.finishSignUpButtonPressed):
                return .run { send in
                    await send(.delegate(.finishSignUp))
                }
                
            case .internal(.previousStep):
                return .run { send in
                    await send(.delegate(.previousStep))
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
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
                
            }
        }
    }
}
