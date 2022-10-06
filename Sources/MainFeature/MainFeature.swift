import Foundation
import ComposableArchitecture
import SwiftUI
import UserDefaultsClient
import UserModel

public struct Main: ReducerProtocol {
    @Dependency(\.userDefaultsClient) var userDefaultsClient
    public init() {}
}

public extension Main {
    struct State: Equatable {
        public var jwt: String
        
        public init(jwt: String) {
            self.jwt = jwt
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
                        Text("JWT TOKEN: ")
                        Text(viewStore.state.jwt)
                    }
                    
                    Button("Log out user") {
                        viewStore.send(.internal(.logOutUser))
                    }
                }
            }
        }
    }
}
