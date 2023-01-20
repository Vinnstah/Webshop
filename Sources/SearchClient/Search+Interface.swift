import Foundation
import Product
import AsyncExtensions

public struct SearchClient: Sendable {
    public typealias SearchInput = @Sendable (String) async throws -> Void
    public typealias ObserveSearchInput = @Sendable () async throws -> AnyAsyncSequence<String>
    
    public var sendSearchInput: SearchInput
    public var observeSearchInput: ObserveSearchInput
}
