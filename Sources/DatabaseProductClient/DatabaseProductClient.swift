import PostgresNIO
import Foundation
import Product
import Dependencies
import Database

public struct DatabaseProductClient: Sendable, DependencyKey {
    public typealias GetAllProducts = @Sendable (GetAllProductsRequest) async throws -> [Product]
    public typealias Connect = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var getAllProducts: GetAllProducts
    public var connect: Connect
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
}


extension DatabaseProductClient {
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(
            getAllProducts: {
                try await database.fetchAllProducts(request: $0)
            }, connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
            
        )
    }()
}

public struct GetAllProductsRequest: Sendable {
    public let db: PostgresConnection
    
    public init(db: PostgresConnection) {
        self.db = db
    }
}
