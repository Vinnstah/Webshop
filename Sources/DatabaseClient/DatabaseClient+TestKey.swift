
import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay
import Dependencies

extension DatabaseClient {
    
    static let test = Self(
        fetchBoardgames: XCTUnimplemented("\(Self.self).fetchBoardgames"),
        createCartSession: XCTUnimplemented("\(Self.self).createCartSession"),
        getAllItemsInCart: XCTUnimplemented("\(Self.self).getAllItemsInCart"),
        fetchCartSession: XCTUnimplemented("\(Self.self).fetchCartSession"),
        insertItemsToCart: XCTUnimplemented("\(Self.self).insertItemsToCart"),
        createUser: XCTUnimplemented("\(Self.self).createUsercreateUser"),
        fetchLoggedInUserJWT: XCTUnimplemented("\(Self.self).fetchLoggedInUserJWT"),
        signInUser: XCTUnimplemented("\(Self.self).signInUser"),
        fetchWarehouse: XCTUnimplemented("\(Self.self).fetchWarehouse"),
        fetchWarehouseStatusForProduct: XCTUnimplemented("\(Self.self).fetchWarehouseStatusForProduct"),
        updateWarehouse: XCTUnimplemented("\(Self.self).updateWarehouse"),
        connect: XCTUnimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: XCTUnimplemented("\(Self.self).closeDatabaseEventLoop")
    )
}
extension DatabaseClient: TestDependencyKey {
    public static let testValue = DatabaseClient.test
}

public extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}
