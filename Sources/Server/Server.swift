import Vapor
import VaporRouting
import SiteRouter
import UserModel


// configures your application
public func configure(_ app: Application) throws {
    
    app.mount(router, use: siteHandler)
    
}

/// Handles all the actions for each route
func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .create(request):
        let db = try await connectDatabase()
        
        let jwt = constructJWT(
            secretKey: request.password,
            header: JWT.Header.init(),
            payload: JWT.Payload(name: request.email)
        )
        
        let user = User(
            email: request.email,
            password: request.hexedPassword,
            jwt: jwt
        )
        
        try await insertUser(db, logger: logger, user: user)
        try await db.close()
        return ResultPayload(forAction: "create", payload: user.jwt)
        
    case let .login(request):
        let db = try await connectDatabase()
        let jwt = try await loginUser(db, request.email, request.hexedPassword)
        try await db.close()
        return ResultPayload(forAction: "login", payload: jwt)
        
    case .getProducts:
        let db = try await connectDatabase()
        let products = try await getAllProducts(db)
        try await db.close()
        return ResultPayload(forAction: "getProducts", payload: products)
    case .getCategories:
        let db = try await connectDatabase()
        let categories = try await getAllCategories(db)
        try await db.close()
        return ResultPayload(forAction: "getCategories", payload: categories)
    case .getSubCategories:
        let db = try await connectDatabase()
        let categories = try await getAllSubCategories(db)
        try await db.close()
        return ResultPayload(forAction: "getSubCategories", payload: categories)
    
    case let .addCartSession(cart):
        let db = try await connectDatabase()
        try await addShoppingCartSession(db, logger: logger, jwt: cart.userJWT ?? "", sessionID: cart.id)
        try await db.close()
        return ResultPayload(forAction: "addShoppingCartSession", payload: cart.id)
    
    case let .addShoppingCartItems(cart):
        let db = try await connectDatabase()
        try await addShoppingCartProducts(db, logger: logger, cart: cart)
        try await db.close()
        return ResultPayload(forAction: "addShoppingCartProducts", payload: cart.id)
    }
    
}


extension ResultPayload: Content {}
