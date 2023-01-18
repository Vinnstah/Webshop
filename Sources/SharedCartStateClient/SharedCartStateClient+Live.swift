import Dependencies
import Foundation
import CartModel
import Combine
import XCTestDynamicOverlay

extension SharedCartStateClient: DependencyKey {
    
    public static var liveValue: SharedCartStateClient {
        var value: Cart? = nil
        return Self(
            sendAction: { value = $0 } ,
            observeAction: { AsyncStream { cont in
                guard let value else {
                    return cont.finish()
                }
                cont.yield(value)
            }
            }
        )
    }
}
