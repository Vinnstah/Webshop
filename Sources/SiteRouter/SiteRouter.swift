import URLRouting
import ComposableArchitecture
import UserModel
import CartModel


//TODO: Rename annd remove `get`, `add`
public enum SiteRoute: Equatable {
    case create(User)
    case login(User)
    case getProducts
    case getCategories
    case getSubCategories
    case addCartSession(Cart)
    case addShoppingCartItems(Cart)
}


public let router = OneOf {
    Route(.case(SiteRoute.create)) {
        Path { "create" }
        Method.post
        Body(.json(User.self))
    }
    Route(.case(SiteRoute.login)) {
        Path { "login" }
        Method.post
        Body(.json(User.self))
    }
    Route(.case(SiteRoute.getProducts)) {
        Path { "getProducts" }
    }
    Route(.case(SiteRoute.getCategories)) {
        Path { "getCategories" }
    }
    Route(.case(SiteRoute.getSubCategories)) {
        Path { "getSubCategories" }
    }
    Route(.case(SiteRoute.addCartSession)) {
        Path { "addCartSession" }
        Method.post
        Body(.json(Cart.self))
    }
    Route(.case(SiteRoute.addShoppingCartItems)) {
        Path { "addShoppingCartItems" }
        Method.post
        Body(.json(Cart.self))
    }
}


public struct ResultPayload<Payload: Sendable & Equatable & Codable>: Codable, Sendable, Equatable {
    public let forAction: String
    public let payload: Payload?
    public var status: Result<Payload, Failure> {
        guard let payload else {
            return .failure(.failure)
        }
        return .success(payload)
    }
    
    public init(forAction: String, payload: Payload?) {
        self.forAction = forAction
        self.payload = payload
    }
    

    public enum Failure: String, Error, Sendable, Codable {
        case failure
    }
}


public struct CreateUserResponse: Codable, Equatable {
    let email: String
    let jwt: String
    let status: String
    
    public init(email: String, jwt: String, status: String) {
        self.email = email
        self.jwt = jwt
        self.status = status
    }
}
