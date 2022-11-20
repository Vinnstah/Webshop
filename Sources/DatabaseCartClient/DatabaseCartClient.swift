import PostgresNIO
import Foundation
import CartModel

public struct DatabaseCartClient: Sendable {
    public typealias CreateCartSession = @Sendable (PostgresConnection, Cart) async throws -> Cart.Session.ID
    public typealias GetAllItemsInCart = @Sendable (PostgresConnection, Cart.Session) async throws -> [Cart.Item]
    public typealias FetchCartSession = @Sendable (PostgresConnection, String) async throws -> Cart?
    public typealias InsertItemsToCart = @Sendable (PostgresConnection, Cart) async throws -> Cart.Session.ID?
    
    public var createCartSession: CreateCartSession
    public var getAllItemsInCart: GetAllItemsInCart
    public var fetchCartSession: FetchCartSession
    public var insertItemsToCart: InsertItemsToCart
    
    public init(
        createCartSession: @escaping CreateCartSession,
        getAllItemsInCart: @escaping GetAllItemsInCart,
        fetchCartSession: @escaping FetchCartSession,
        insertItemsToCart: @escaping InsertItemsToCart
    ) {
        self.createCartSession = createCartSession
        self.getAllItemsInCart = getAllItemsInCart
        self.fetchCartSession = fetchCartSession
        self.insertItemsToCart = insertItemsToCart
    }
    
}
