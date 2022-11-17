import Foundation
import PostgresNIO
import Warehouse
import Product

public extension Database {
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
