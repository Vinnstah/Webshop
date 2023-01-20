import Dependencies
import Foundation

#if DEBUG
import XCTestDynamicOverlay

extension SearchClient {
    
    public static let test = Self(
        sendSearchInput: XCTUnimplemented("\(Self.self).sendAction"),
        observeSearchInput: XCTUnimplemented("\(Self.self).observeActions")
    )
}
    
    extension SearchClient: TestDependencyKey {
        public static let testValue = SearchClient.test
    }
#endif

public extension DependencyValues {
    var searchClient: SearchClient {
        get { self[SearchClient.self] }
        set { self[SearchClient.self] = newValue }
    }
}
