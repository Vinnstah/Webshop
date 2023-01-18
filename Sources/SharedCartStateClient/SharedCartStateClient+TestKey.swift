import Dependencies
import Foundation

#if DEBUG
import XCTestDynamicOverlay

extension SharedCartStateClient {
    
    public static let test = Self(
        sendAction: XCTUnimplemented("\(Self.self).sendAction"),
        observeAction: XCTUnimplemented("\(Self.self).observeActions")
    )
}
    
    extension SharedCartStateClient: TestDependencyKey {
        public static let testValue = SharedCartStateClient.test
    }
#endif

public extension DependencyValues {
    var cartStateClient: SharedCartStateClient {
        get { self[SharedCartStateClient.self] }
        set { self[SharedCartStateClient.self] = newValue }
    }
}
