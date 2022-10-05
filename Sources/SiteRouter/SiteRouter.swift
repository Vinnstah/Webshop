import Vapor
import VaporRouting
import ComposableArchitecture
import UserModel


public enum SiteRoute: Equatable {
    case create(User)
    case login(User)
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
}


public struct ResultPayload: Content, Sendable, Equatable {
    public let forAction: String
    public let status: Status
    public let data: String
    
    public init(forAction: String, status: Status, data: String) {
        self.forAction = forAction
        self.status = status
        self.data = data
    }
    
    public enum Status: Content, Sendable, Equatable {
        case failedToLogin
        case successfulLogin
    }
}


public struct CreateUserResponse: Content, Equatable {
    let email: String
    let jwt: String
    let status: String
    
    public init(email: String, jwt: String, status: String) {
        self.email = email
        self.jwt = jwt
        self.status = status
    }
}
