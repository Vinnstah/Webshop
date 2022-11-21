import Vapor
import VaporRouting
import SiteRouter
import UserModel
import ComposableArchitecture
import DatabaseClientLive
import BoardgameService
import CartService
import UserService
import WarehouseService

public struct Server: Sendable {
    public struct State : Sendable{
        public let boardgameService: BoardgameService
        public let cartService: CartService
        public let userService: UserService
        public let warehouseService: WarehouseService
        
        public init(
            boardgameService: BoardgameService = .init(),
            cartService: CartService = .init(),
            userService: UserService = .init(),
            warehouseService: WarehouseService = .init()
        ) {
            self.boardgameService = boardgameService
            self.cartService = cartService
            self.userService = userService
            self.warehouseService = warehouseService
        }
    }
    
    let state: State
    
    public init(state: State = .init()) {
        self.state = state
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
            return try await state.boardgameService.boardgameHandler(route: route, request: request)
            
        case let .cart(route):
            return try await state.cartService.cartHandler(route: route, request: request)
            
        case let .users(route):
            return try await state.userService.usersHandler(route: route, request: request)
            
        case let .warehouse(route):
            return try await state.warehouseService.warehouseHandler(route: route, request: request)
        }
    }
    
}
