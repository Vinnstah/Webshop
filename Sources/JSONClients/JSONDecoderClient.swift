import Dependencies
import Foundation

// MARK: - JSONDecoder + DependencyKey
extension JSONDecoder: DependencyKey {
    public typealias Value = @Sendable () -> JSONDecoder

    public static let liveValue = { @Sendable in
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    public static var previewValue: Value { liveValue }
}

// MARK: - JSONDecoder + Sendable
extension JSONDecoder: @unchecked Sendable {}

public extension DependencyValues {
    var jsonDecoder: JSONDecoder.Value {
        get { self[JSONDecoder.self] }
        set { self[JSONDecoder.self] = newValue }
    }
}

#if DEBUG
import XCTestDynamicOverlay

extension JSONDecoder: TestDependencyKey {
    public static var testValue: Value = unimplemented("\(JSONDecoder.self)")
}
#endif // DEBUG
