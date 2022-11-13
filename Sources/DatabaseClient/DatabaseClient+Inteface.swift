import PostgresNIO
import Foundation
import Product
import CartModel
import Boardgame
import UserModel
import Warehouse

public struct DatabaseClient: Sendable {
    public typealias FetchBoardgames = @Sendable (PostgresConnection) async throws -> [Boardgame]
    public typealias CreateCartSession = @Sendable (PostgresConnection, Cart) async throws -> Cart.Session.ID
    public typealias GetAllItemsInCart = @Sendable (PostgresConnection, Cart.Session) async throws -> [Cart.Item]
    public typealias FetchCartSession = @Sendable (PostgresConnection, String) async throws -> Cart?
    public typealias InsertItemsToCart = @Sendable (PostgresConnection, Cart) async throws -> Cart.Session.ID?
    public typealias CreateUser = @Sendable (PostgresConnection, User, String) async throws -> Void
    public typealias FetchLoggedInUserJWT = @Sendable (PostgresConnection, User) async throws -> String
    public typealias SignInUser = @Sendable (PostgresConnection, User) async throws -> String?
    public typealias FetchWarehouse = @Sendable (PostgresConnection) async throws -> [Warehouse.Item]
    public typealias FetchWarehouseStatusForProduct = @Sendable (PostgresConnection, String) async throws -> [Warehouse.Item]
    public typealias UpdateWarehouse = @Sendable (PostgresConnection, Warehouse.Item) async throws -> String?
    public typealias ConnectToDatabase = @Sendable () async throws -> (PostgresConnection)
    public typealias CloseDatabaseEventLoop = @Sendable () -> Void
    
    public var fetchBoardgames: FetchBoardgames
    public var createCartSession: CreateCartSession
    public var getAllItemsInCart: GetAllItemsInCart
    public var fetchCartSession: FetchCartSession
    public var insertItemsToCart: InsertItemsToCart
    public var createUser: CreateUser
    public var fetchLoggedInUserJWT: FetchLoggedInUserJWT
    public var signInUser: SignInUser
    public var fetchWarehouse: FetchWarehouse
    public var fetchWarehouseStatusForProduct: FetchWarehouseStatusForProduct
    public var updateWarehouse: UpdateWarehouse
    public var connectToDatabase: ConnectToDatabase
    public var closeDatabaseEventLoop: CloseDatabaseEventLoop
    
    public init(
        fetchBoardgames: @escaping  FetchBoardgames,
        createCartSession: @escaping CreateCartSession,
        getAllItemsInCart: @escaping GetAllItemsInCart,
        fetchCartSession: @escaping FetchCartSession,
        insertItemsToCart: @escaping InsertItemsToCart,
        createUser: @escaping CreateUser,
        fetchLoggedInUserJWT: @escaping FetchLoggedInUserJWT,
        signInUser: @escaping SignInUser,
        fetchWarehouse: @escaping FetchWarehouse,
        fetchWarehouseStatusForProduct: @escaping FetchWarehouseStatusForProduct,
        updateWarehouse: @escaping UpdateWarehouse,
        connectToDatabase: @escaping ConnectToDatabase,
        closeDatabaseEventLoop: @escaping CloseDatabaseEventLoop
    ) {
        self.fetchBoardgames = fetchBoardgames
        self.createCartSession = createCartSession
        self.getAllItemsInCart = getAllItemsInCart
        self.fetchCartSession = fetchCartSession
        self.insertItemsToCart = insertItemsToCart
        self.createUser = createUser
        self.fetchLoggedInUserJWT = fetchLoggedInUserJWT
        self.signInUser = signInUser
        self.fetchWarehouse = fetchWarehouse
        self.fetchWarehouseStatusForProduct = fetchWarehouseStatusForProduct
        self.updateWarehouse = updateWarehouse
        self.connectToDatabase = connectToDatabase
        self.closeDatabaseEventLoop = closeDatabaseEventLoop
    }
    
}
