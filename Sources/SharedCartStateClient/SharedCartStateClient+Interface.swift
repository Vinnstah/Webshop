import Foundation
import CartModel
import Product
import AsyncExtensions

public struct SharedCartStateClient: Sendable {
    public typealias SendAction = (Cart) async -> Void
    public typealias ObserveAction = () async throws -> AnyAsyncSequence<Cart?>
    
    public var sendAction: SendAction
    public var observeAction: ObserveAction
}
