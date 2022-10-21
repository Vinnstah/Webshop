import Foundation
import CheckoutModel
import ComposableArchitecture

public struct Checkout: ReducerProtocol {
    public init() {}
}

public extension Checkout {
    struct State: Equatable, Sendable {
        public var checkout: CheckoutModel?
        
        public init(
            checkout: CheckoutModel? = nil
        ) {
            self.checkout = checkout
        }
    }
    
    enum Action: Equatable, Sendable {
        case `internal`(InternalAction)
        case delegate(DelegateAction)
        
        public enum DelegateAction: Equatable, Sendable {
        }
        
        public enum InternalAction: Equatable, Sendable {
        }
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .internal(_):
                return .none
                
            case .delegate(_):
                return .none
                
            }
        }
    }
}



