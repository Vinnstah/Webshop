import Foundation
import PostgresNIO
import Warehouse
import Product
import Database
import DatabaseWarehouseClient

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
        request: FetchWarehouseStatusForProductRequest
    ) async throws -> [Warehouse.Item] {
        let rows = try await request.db.query(
                    """
                    SELECT * FROM warehouse
                    WHERE prod_id=\(request.id);
                    """,
                    logger: logger
        )
        let warehouse = try await decodeItemStatus(from: rows)
        return warehouse
    }
    
     func updateWarehouse(
        request: UpdateWarehouseRequest
    ) async throws -> String? {
        try await request.db.query(
                    """
                    INSERT INTO warehouse
                    VALUES(\(request.item.id.rawValue), \(request.item.product.rawValue), \(request.item.quantity.rawValue))
                    ON CONFLICT (warehouse_id)
                    DO UPDATE
                    SET quantity=\(request.item.quantity.rawValue);
                    """,
                    logger: logger
        )
        return request.item.id.rawValue.uuidString
    }
}

