import Foundation
import PostgresNIO
import Warehouse

public struct FetchWarehouseStatusForProductRequest: Sendable {
    public let db: PostgresConnection
    public let id: String
    
    public init(db: PostgresConnection, id: String) {
        self.db = db
        self.id = id
    }
}

public struct UpdateWarehouseRequest: Sendable {
    public let db: PostgresConnection
    public let item: Warehouse.Item
    
    public init(db: PostgresConnection, item: Warehouse.Item) {
        self.db = db
        self.item = item
    }
}
