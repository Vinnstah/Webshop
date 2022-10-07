//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-10-07.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel

extension AlertState: @unchecked Sendable {}
public struct UserInformation: ReducerProtocol {
    public init() {}
}


public extension UserInformation {
    
    struct State: Equatable, Sendable {
        public var userSettings: UserSettings?
        public var alert: AlertState<Action>?
        
        
        public init(
            userSettings: UserSettings? = nil,
            alert: AlertState<Action>? = nil
        ) {
            self.userSettings = userSettings
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
            case defaultCurrencyChosen(Currency)
            case alertConfirmTapped
        }
        
        public enum DelegateAction: Equatable, Sendable {
            case nextStep
            case previousStep
            case goBackToLoginView
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            
            switch action {
                
            case .internal(.nextStep):
                return .run { send in
                    await send(.delegate(.nextStep))
                }
                
            case .internal(.previousStep):
                return .run { send in
                    await send(.delegate(.previousStep))
                }
            
                
            case let .internal(.defaultCurrencyChosen(currency)):
                state.userSettings?.defaultCurrency = currency
                return .none
                
            case .internal(.cancelButtonPressed):
                return .run { send in
                    await send(.delegate(.goBackToLoginView))
                }
                

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

//public func doesEmailMeetRequirements(email: String) -> Bool? {
//    guard let regex = try? Regex(#"^[^\s@]+@([^\s@.,]+\.)+[^\s@.,]{2,}$"#) else { return nil }
//    if email.wholeMatch(of: regex) != nil {
//        return true
//    }
//    return false
//}

