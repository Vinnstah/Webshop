import PostgresNIO
import Foundation
import CartModel
import Dependencies
import Database

public struct DatabaseCartClient: Sendable, DependencyKey {
    public typealias CreateCartSession = @Sendable (CreateCartSessionRequest) async throws -> Cart.Session
    public typealias GetAllItemsInCart = @Sendable (GetAllItemsInCartRequest) async throws -> [Cart.Item]
    public typealias FetchCartSession = @Sendable (FetchCartSessionRequest) async throws -> Cart?
    public typealias InsertItemsToCart = @Sendable (InsertItemsToCartRequest) async throws -> Cart.Session.ID?
    public typealias Connect = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var createCartSession: CreateCartSession
    public var getAllItemsInCart: GetAllItemsInCart
    public var fetchCartSession: FetchCartSession
    public var insertItemsToCart: InsertItemsToCart
    public var connect: Connect
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
    
}

extension DatabaseCartClient {
    public static let liveValue: Self = {
        let database = Database()
        
        return Self.init(
            createCartSession: {
                try await database.createCartSession(request: $0)
                
            }, getAllItemsInCart: {
                try await database.getAllItemsInCart(request: $0)
                
            }, fetchCartSession: {
                try await database.fetchCartSession(request: $0)
                
            }, insertItemsToCart: {
                try await database.insertItemsToCart(request: $0)
            }, connect: {
                try await database.connect()
            },
            closeDatabaseEventLoop: {
                database.closeDatabaseEventLoop()
            }
        )
    }()
}
