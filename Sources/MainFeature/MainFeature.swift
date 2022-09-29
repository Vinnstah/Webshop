//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-25.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient

public struct Main: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    public init() {}
}

public extension Main {
    struct State: Equatable {
        public var defaultCurreny: String
        public var token: String
        
        public init(defaultCurrency: String, token: String) {
            self.defaultCurreny = defaultCurrency
            self.token = token
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
            case userIsLoggedOut
        }
        
        public enum InternalAction: Equatable, Sendable {
            case logOutUser
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .internal(.logOutUser):
                return .run { [userDefaultsClient] send in
                    await userDefaultsClient.setIsLoggedIn(false)
                    await send(.delegate(.userIsLoggedOut))
                }
            case .delegate(_):
                return .none
            }
        }
    }
    
}



public extension Main {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Main>
        
        public init(store: StoreOf<Main>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("Main Feature goes here")
                    
                    HStack {
                        Text("Default currency: ")
                        Text(viewStore.state.defaultCurreny)
                    }
                    
                    HStack {
                        Text("JWT TOKEN: ")
                        Text(viewStore.state.token)
                    }
                    
                    Button("Log out user") {
                        viewStore.send(.internal(.logOutUser))
                    }
                }
            }
        }
    }
}
