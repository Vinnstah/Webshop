import Foundation
import CartModel
import Product

public struct SharedCartStateClient: Sendable {
    public typealias SendAction = (Cart) async -> Void
    public typealias ObserveAction = () async throws -> AsyncStream<Cart>
    
    public var sendAction: SendAction
    public var observeAction: ObserveAction
}
