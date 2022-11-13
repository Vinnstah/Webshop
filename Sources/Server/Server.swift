import Vapor
import VaporRouting
import SiteRouter
import UserModel
import ComposableArchitecture
import DatabaseLive

public struct Server: Sendable {
    @Dependency(\.databaseClient) var databaseClient
    public init() {}
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
            return try await boardgameHandler(route: route, request: request)
            
        case let .cart(route):
            return try await cartHandler(route: route, request: request)
            
        case let .users(route):
            return try await usersHandler(route: route, request: request)
            
        case let .warehouse(route):
            return try await warehouseHandler(route: route, request: request)
        }
    }
    
}
extension ResultPayload: Content {}
