import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay
import Dependencies

extension DatabaseCartClient {
    
    static let test = Self(
        createCartSession: XCTUnimplemented("\(Self.self).createCartSession"),
        getAllItemsInCart: XCTUnimplemented("\(Self.self).getAllItemsInCart"),
        fetchCartSession: XCTUnimplemented("\(Self.self).fetchCartSession"),
        insertItemsToCart: XCTUnimplemented("\(Self.self).insertItemsToCart")
    )
}
extension DatabaseCartClient: TestDependencyKey {
    public static let testValue = DatabaseCartClient.test
}

public extension DependencyValues {
    var databaseCartClient: DatabaseCartClient {
        get { self[DatabaseCartClient.self] }
        set { self[DatabaseCartClient.self] = newValue }
    }
}
