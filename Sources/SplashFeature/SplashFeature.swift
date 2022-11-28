import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient

/// Determine if user should be onboarded or not and reporting the result back to AppFeature
public struct Splash: ReducerProtocol, Sendable {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    @Dependency(\.mainQueue) var mainQueue
    
    public init(){}
}

public extension Splash {
    struct State: Equatable {
        public var isAnimating: Bool
        
        public init(isAnimating: Bool = false
        ){
            self.isAnimating = isAnimating
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
            case loadIsLoggedInResult(String?)
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
                
                // On appear send action to userDefaultsClient to check if user is logged in
            case .internal(.onAppear):
                state.isAnimating.toggle()
                return .run { send in
                    try await self.mainQueue.sleep(for: .milliseconds(1000))
                    await send(
                        .delegate(
                            .loadIsLoggedInResult(self.userDefaultsClient.getLoggedInUserJWT())
                        ), animation: .default
                    )
                }
            }
        }
    }
}

extension Animation : @unchecked Sendable {}
