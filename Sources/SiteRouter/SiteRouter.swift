import Vapor
import VaporRouting
import ComposableArchitecture


public enum SiteRoute: Equatable {
    case login(UserModel)
}


public let router = OneOf {
    Route(.case(SiteRoute.login)) {
        Path { "login" }
        Method.post
        Body(.json(UserModel.self))
    }
}


public struct LoginResponse: Content, Sendable, Equatable {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    public enum CodingKeys: String, CodingKey {
        case token = "token"
    }
    
    public enum ServerError: Content, Equatable, Sendable, Error {
        case failedToGetServerResponse
    }
}
