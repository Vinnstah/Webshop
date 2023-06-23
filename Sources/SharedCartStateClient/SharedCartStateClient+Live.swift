import Dependencies
import Foundation
import CartModel
import Combine
import XCTestDynamicOverlay
import AsyncExtensions

extension SharedCartStateClient: DependencyKey {
    
    public static var liveValue: SharedCartStateClient {
        
        actor CartHolder: Sendable {
            
            // uses `AsyncBufferedChannel` from: https://github.com/sideeffect-io/AsyncExtensions
            // MUST have this if you PRODUCE values in one Task and CONSUME values in another,
            // which one very very often would like to do. AsyncStream DOES NOT support this.
            private let cartChannel: AsyncThrowingBufferedChannel<Cart?, Swift.Error> = .init()
            private let replaySubject: AsyncThrowingReplaySubject<Cart?, Swift.Error> = .init(bufferSize: 1)
            
            //              private let cartChannel: AsyncCurrentValueSubject<Cart?> = .init(nil)
            init() {}
            
            func emit(_ cart: Cart?) {
                cartChannel.send(cart)
            }
            
            // uses `AnyAsyncSequence` from: https://github.com/sideeffect-io/AsyncExtensions
            func cartAsyncSequence() -> AnyAsyncSequence<Cart?> {
                cartChannel
                    .multicast(replaySubject)
                    .autoconnect()
                
                //                    .share() // <-- VERY VERY important if you are going to be consuming the values in MULTIPLE Tasks, nor AsyncStream of AsyncBufferedChannel supports this
                    .eraseToAnyAsyncSequence()
                //                    .eraseToAnyAsyncSequence() // hide the implementation details that this is a shared (multicasted) async sequence with an AsyncBufferedChannel as "Upstream"/"Base"
            }
        }
        
        let cartHolder = CartHolder()
        
        return Self(
            sendAction: { await cartHolder.emit($0) } ,
            observeAction: { await cartHolder.cartAsyncSequence() }
        )
    }
}