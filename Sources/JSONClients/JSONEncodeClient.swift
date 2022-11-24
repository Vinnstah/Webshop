import Dependencies
import Foundation

// MARK: - JSONEncoder + DependencyKey
extension JSONEncoder: DependencyKey {
    public typealias Value = @Sendable () -> JSONEncoder

    public static let liveValue = { @Sendable in
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    public static var previewValue: Value { liveValue }
}

// MARK: - JSONEncoder + Sendable
extension JSONEncoder: @unchecked Sendable {}

public extension DependencyValues {
    var jsonEncoder: JSONEncoder.Value {
        get { self[JSONEncoder.self] }
        set { self[JSONEncoder.self] = newValue }
    }
}

#if DEBUG
import XCTestDynamicOverlay

extension JSONEncoder: TestDependencyKey {
    public static var testValue: Value = unimplemented("\(JSONEncoder.self)")
}
#endif // DEBUG
