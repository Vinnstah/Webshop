import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay
import Dependencies

extension DatabaseWarehouseClient {
    
    static let test = Self(
        fetchWarehouse: XCTUnimplemented("\(Self.self).fetchWarehouse"),
        fetchWarehouseStatusForProduct: XCTUnimplemented("\(Self.self).fetchWarehouseStatusForProduct"),
        updateWarehouse: XCTUnimplemented("\(Self.self).updateWarehouse"),
        connect: XCTUnimplemented("\(Self.self).connect"),
        closeDatabaseEventLoop: XCTUnimplemented("\(Self.self).closeDatabaseEventLoop")
    )
}
extension DatabaseWarehouseClient: TestDependencyKey {
    public static let testValue = DatabaseWarehouseClient.test
}

public extension DependencyValues {
    var databaseWarehouseClient: DatabaseWarehouseClient {
        get { self[DatabaseWarehouseClient.self] }
        set { self[DatabaseWarehouseClient.self] = newValue }
    }
}
