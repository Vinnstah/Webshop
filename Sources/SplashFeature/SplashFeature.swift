//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-22.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient

public enum IsLoggedIn: Equatable, Sendable {
    case isLoggedIn
    case notLoggedIn
    
    public init(_ isLoggedIn: Bool) {
        self = isLoggedIn ? .isLoggedIn : .notLoggedIn
    }
}

/// Determine if user should be onboarded or not and reporting the result back to AppFeature
public struct Splash: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.mainQueue) var mainQueue
    
    public init(){}
}

public extension Splash {
    struct State: Equatable {
        public init(){}
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
            case loadIsLoggedInResult(IsLoggedIn)
        }
        
        public enum InternalAction: Equatable, Sendable {
            case onAppear
        }
    }
     
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .delegate:
                return .none
                
            case .internal(.onAppear):
                return .run { [userDefaultsClient, mainQueue] send in
                    try await mainQueue.sleep(for: .milliseconds(700))
                    await send(
                        .delegate(
                            .loadIsLoggedInResult(
                                .init(userDefaultsClient.getIsLoggedIn())
                            )
                        )
                    )
                }
            }
        }
    }
}

public extension Splash {
    struct View: SwiftUI.View {
        public let store: StoreOf<Splash>
        
        public init(store: StoreOf<Splash>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Text("SPLASH SCREEN")
                    .onAppear {
                        viewStore.send(.internal(.onAppear))
                    }
                    .background(Color.red)
                
                
            }
        }
    }
}
