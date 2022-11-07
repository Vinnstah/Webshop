import Vapor
import VaporRouting
import SiteRouter
import UserModel

// configures your application
public func configure(_ app: Application) throws {
    
    app.mount(router, use: siteHandler)
    
}

func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .boardgame(route):
        return try await boardgameHandler(route: route)
    case let .cart(route):
        return try await cartHandler(route: route)
    case let .users(route):
        return try await usersHandler(route: route)
    case let .warehouse(route):
        return try await warehouseHandler(route: route)
    }
}






//
///// Handles all the actions for each route
//func siteHandler(
//    request: Request,
//    route: SiteRoute
//) async throws -> any AsyncResponseEncodable {
//    switch route {
//    case let .create(request):
//        let db = try await connectDatabase()
//
//        let jwt = constructJWT(
//            secretKey: request.password,
//            header: JWT.Header.init(),
//            payload: JWT.Payload(name: request.email)
//        )
//
//        let user = User(
//            email: request.email,
//            password: request.hexedPassword,
//            jwt: jwt
//        )
//
//        try await insertUser(db, logger: logger, user: user)
//        try await db.close()
//        return ResultPayload(forAction: "create", payload: user.jwt)
//
//    case let .login(request):
//        let db = try await connectDatabase()
//        let jwt = try await loginUser(db, request.email, request.hexedPassword)
//        try await db.close()
//        return ResultPayload(forAction: "login", payload: jwt)
//
//    case .getProducts:
//        let db = try await connectDatabase()
//        let products = try await getAllProducts(db)
//        try await db.close()
//        return ResultPayload(forAction: "getProducts", payload: products)
//
//    case .getCategories:
//        let db = try await connectDatabase()
//        let categories = try await getAllCategories(db)
//        try await db.close()
//        return ResultPayload(forAction: "getCategories", payload: categories)
//
//    case .getSubCategories:
//        let db = try await connectDatabase()
//        let categories = try await getAllSubCategories(db)
//        try await db.close()
//        return ResultPayload(forAction: "getSubCategories", payload: categories)
//
//    case let .addCartSession(cart):
//        let db = try await connectDatabase()
//        try await addShoppingCartSession(db, logger: logger, cart: cart)
//        try await db.close()
//        return ResultPayload(forAction: "addCartSession", payload: "dbID")
//
//    case let .addShoppingCartItems(cart):
//        let db = try await connectDatabase()
//        try await addShoppingCartProducts(db, logger: logger, cart: cart)
//        try await db.close()
//        return ResultPayload(forAction: "addShoppingCartItems", payload: cart.id)
//
//    case .shoppingSessionDatabaseID:
//        let db = try await connectDatabase()
//        let sessions = try await getCartSessions(db)
//        try await db.close()
//        return ResultPayload(forAction: "shoppingSessionDatabaseID", payload: sessions)
//
//    case let .shoppingCartSessionProducts(id):
//        let db = try await connectDatabase()
//        let cart = try await getShoppingCartProducts(db, logger: logger, sessionID: id)
//        try await db.close()
//        return ResultPayload(forAction: "shoppingCartSessionProducts", payload: cart)
//    }
//
//
//}
//
//
extension ResultPayload: Content {}
