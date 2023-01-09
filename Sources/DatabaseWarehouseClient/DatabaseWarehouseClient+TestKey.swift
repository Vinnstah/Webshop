import Foundation
import Dependencies

#if DEBUG
import XCTestDynamicOverlay

extension DatabaseWarehouseClient {
    
    static let test = Self(
        fetchWarehouse: unimplemented("\(FetchWarehouse.self)"),
        fetchWarehouseStatusForProduct: unimplemented("\(FetchWarehouseStatusForProduct.self)"),
        updateWarehouse: unimplemented("\(UpdateWarehouse.self)"),
        connect: unimplemented("\(Connect.self)"),
        closeDatabaseEventLoop: unimplemented("\(CloseDatabaseEventLoop.self)")
    )
}

extension DatabaseWarehouseClient: TestDependencyKey {
    public static let testValue = DatabaseWarehouseClient.test
}
#endif // DEBUG

public extension DependencyValues {
    var databaseWarehouseClient: DatabaseWarehouseClient {
        get { self[DatabaseWarehouseClient.self] }
        set { self[DatabaseWarehouseClient.self] = newValue }
    }
}
