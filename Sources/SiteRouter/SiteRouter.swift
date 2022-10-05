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

public struct LoginResponse: Content, Sendable, Equatable {
    public let status: [String: String]
    
    public init(status: [String: String] = [:]) {
        self.status = status
    }
    
    public enum CodingKeys: String, CodingKey {
        case status = "status"
    }
    
    public enum ServerError: Content, Equatable, Sendable, Error {
        case failedToGetServerResponse
    }
}

public struct ResultPayload<T: Codable>: Content {
    let forAction: String
    let status: Bool
    let data: T?
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
