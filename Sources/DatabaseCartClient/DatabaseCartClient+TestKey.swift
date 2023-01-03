import Foundation
import Dependencies

#if DEBUG
import XCTestDynamicOverlay

extension DatabaseCartClient {
    
    static let test = Self(
        createCartSession: unimplemented("\(Self.self).createCartSession"),
        getAllItemsInCart: unimplemented("\(Self.self).getAllItemsInCart"),
        fetchCartSession: unimplemented("\(Self.self).fetchCartSession"),
        insertItemsToCart: unimplemented("\(Self.self).insertItemsToCart"),
        removeItemFromCart: unimplemented("\(Self.self).removeItemFromCart"),
        connect: unimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: unimplemented("\(Self.self).closeDatabaseEventLoop")
    )
}
extension DatabaseCartClient: TestDependencyKey {
    public static let testValue = DatabaseCartClient.test
}
#endif // DEBUG

public extension DependencyValues {
    var databaseCartClient: DatabaseCartClient {
        get { self[DatabaseCartClient.self] }
        set { self[DatabaseCartClient.self] = newValue }
    }
}
