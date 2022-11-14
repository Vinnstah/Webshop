import Foundation
import PostgresNIO
import Warehouse
import Product

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
    
     func decodeWarehouseStatus(
        from rows: PostgresRowSequence
    ) async throws -> [Warehouse.Item] {
        
        var warehouse: [Warehouse.Item] = []
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            let product = try Warehouse.Item(
                id: Warehouse.Item.ID(rawValue: randomRow["warehouse_id"].decode(UUID.self, context: .default)),
                product: Product.ID(rawValue: randomRow["prod_id"].decode(UUID.self, context: .default)),
                quantity: Warehouse.Item.Quantity(rawValue: randomRow["quantity"].decode(Int.self, context: .default))
            )
            warehouse.append(product)
        }
        return warehouse
    }
    
     func decodeItemStatus(
        from rows: PostgresRowSequence
    ) async throws -> [Warehouse.Item] {
        
        var warehouse: [Warehouse.Item] = []
        for try await row in rows {
            let randomRow = row.makeRandomAccess()
            let product = try Warehouse.Item(
                id: Warehouse.Item.ID(rawValue: randomRow["warehouse_id"].decode(UUID.self, context: .default)),
                product: Product.ID(rawValue: randomRow["prod_id"].decode(UUID.self, context: .default)),
                quantity: Warehouse.Item.Quantity(rawValue: randomRow["warehouse_id"].decode(Int.self, context: .default))
            )
            warehouse.append(product)
        }
        return warehouse
    }
}

