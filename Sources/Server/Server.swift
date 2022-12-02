import Vapor
import VaporRouting
import SiteRouter
import UserModel
import ComposableArchitecture
import BoardgameService
import CartService
import UserService
import WarehouseService
import ProductService

public struct Server: Sendable {
        public let boardgameService: BoardgameService
        public let cartService: CartService
        public let userService: UserService
        public let warehouseService: WarehouseService
    public let productService: ProductService
        
        public init(
            boardgameService: BoardgameService = .init(),
            cartService: CartService = .init(),
            userService: UserService = .init(),
            warehouseService: WarehouseService = .init(),
            productService: ProductService = .init()
        ) {
            self.boardgameService = boardgameService
            self.cartService = cartService
            self.userService = userService
            self.warehouseService = warehouseService
            self.productService = productService
        }
}

public extension Server {
    
     func configure(_ app: Application) throws {
        
        app.mount(router, use: siteHandler)
        
    }
    
    func siteHandler(
        request: Request,
        route: SiteRoute
    ) async throws -> any AsyncResponseEncodable {
        
        switch route {
            
        case let .boardgame(route):
            return try await boardgameService.boardgameHandler(route: route, request: request)
            
        case let .cart(route):
            return try await cartService.cartHandler(route: route, request: request)
            
        case let .users(route):
            return try await userService.usersHandler(route: route, request: request)
            
        case let .warehouse(route):
            return try await warehouseService.warehouseHandler(route: route, request: request)
            
        case let .products(route):
            return try await productService.productHandler(route: route, request: request)
        }
    }
    
}
