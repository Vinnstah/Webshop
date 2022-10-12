
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
        public init(){}
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
                return .run { [userDefaultsClient, mainQueue] send in
                    try await mainQueue.sleep(for: .milliseconds(700))
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
                    .background(Color(red: 52, green: 73, blue: 102))
                    .frame(width: 600, height: 400)
               
                
            }
            .background(Color(red: 13, green: 24, blue: 33))
        }
    }
}
