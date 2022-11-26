
import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient


/// Determine if user should be onboarded or not and reporting the result back to AppFeature
public struct Splash: ReducerProtocol {
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
                return .run { [userDefaultsClient, mainQueue] send in
                    try await mainQueue.sleep(for: .milliseconds(3000))
                    await send(
                        .delegate(
                            .loadIsLoggedInResult(userDefaultsClient.getLoggedInUserJWT())
                        )
                    )
                }
            }
        }
    }
}

