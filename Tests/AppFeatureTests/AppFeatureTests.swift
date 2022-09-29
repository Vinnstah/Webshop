import XCTest
@testable import AppFeature

@MainActor
final class AppFeatureTests: XCTestCase {
    func testTrivial() throws {
        XCTAssert(true)
    }
}
