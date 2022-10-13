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
        public var productList: [String]
        
        public init(jwt: String, productList: [String] = ["Test1", "Test2", "Test3"]) {
            self.jwt = jwt
            self.productList = productList
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
                    await userDefaultsClient.removeLoggedInUserJWT()
                    await send(.delegate(.userIsLoggedOut))
                }
            case .delegate(_):
                return .none
            }
        }
    }
    
}



