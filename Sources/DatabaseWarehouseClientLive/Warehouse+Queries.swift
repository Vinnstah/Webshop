import Foundation
import PostgresNIO
import Warehouse
import Product
import Database

public extension Database {
     func fetchWarehouse(
        _ db: PostgresConnection
    ) async throws -> [Warehouse.Item] {
        let rows = try await db.query(
                    """
                    SELECT * FROM warehouse;
                    """,
                    logger: logger
        )
        let warehouse = try await decodeWarehouseStatus(from: rows)
        return warehouse
    }
    
     func fetchWarehouseStatusForProduct(
        from id: String,
        _ db: PostgresConnection
    ) async throws -> [Warehouse.Item] {
        let rows = try await db.query(
                    """
                    SELECT * FROM warehouse
                    WHERE prod_id=\(id);
                    """,
                    logger: logger
        )
        let warehouse = try await decodeItemStatus(from: rows)
        return warehouse
    }
    
     func updateWarehouse(
        with item: Warehouse.Item,
        _ db: PostgresConnection
    ) async throws -> String? {
        try await db.query(
                    """
                    INSERT INTO warehouse
                    VALUES(\(item.id.rawValue), \(item.product.rawValue), \(item.quantity.rawValue))
                    ON CONFLICT (warehouse_id)
                    DO UPDATE
                    SET quantity=\(item.quantity.rawValue);
                    """,
                    logger: logger
        )
        return item.id.rawValue.uuidString
    }
}

