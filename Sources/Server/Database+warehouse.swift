import Foundation
import PostgresNIO
import Warehouse
import Product

public func fetchWarehouse(
    _ db: PostgresConnection
) async throws -> [Warehouse.Item] {
    let rows = try await db.query(
                    """
                    SELECT * FROM warehouse;
                    """,
                    logger: logger
    )
    let warehouse = try await fetchWarehouseStatus(from: rows)
    return warehouse
}

public func fetchWarehouseStatus(from rows: PostgresRowSequence) async throws -> [Warehouse.Item] {
    var warehouse: [Warehouse.Item] = []
    for try await row in rows {
        let randomRow = row.makeRandomAccess()
        let product = Warehouse.Item(
            id: Warehouse.Item.ID(rawValue: try randomRow["warehouse_id"].decode(UUID.self, context: .default)),
            product: Product.ID.init(rawValue: try randomRow["prod_id"].decode(UUID.self, context: .default)),
            quantity: Warehouse.Quantity.init(rawValue: try randomRow["quantity"].decode(Int.self, context: .default))
        )
        warehouse.append(product)
    }
    return warehouse
}
