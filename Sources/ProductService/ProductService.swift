import Vapor
import SiteRouter
import Foundation
import Product
import DatabaseProductClient
import Dependencies

public struct ProductService: Sendable {
    @Dependency(\.databaseProductClient) var databaseProductClient
    public init() {}
}

public extension ProductService {
    func productHandler(
        route: ProductRoute,
        request: Request
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case .fetch:
            let db = try await databaseProductClient.connect()
            let products = try await databaseProductClient.getAllProducts(GetAllProductsRequest(db: db))
            try await db.close()
            return ResultPayload(forAction: "login", payload: products)
        }
    }
}

extension ResultPayload: Content {}
