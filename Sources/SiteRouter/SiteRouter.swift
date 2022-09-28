import Vapor
import VaporRouting


public enum SiteRoute: Equatable {
    case login(UserModel)
}

//public enum LoginRoute: Equatable {
//    case login(UserModel)
//}
//
//public let router = OneOf {
//    Route(.case(SiteRoute.api)) {
//        Path { "api" }
//        loginRouter
//    }
//}

public let router = OneOf {
    Route(.case(SiteRoute.login)) {
        Method.post
        Body(.json(UserModel.self))
    }
}

/// Secret should not be a part of this model
public struct UserModel: Content, Equatable, Codable, Sendable {
    public let username: String
    public let password: String
    public let secret: String
    
    public init(
        username: String,
        password: String,
        secret: String
    ) {
        self.username = username
        self.password = password
        self.secret = secret
    }
}

public struct LoginResponse: Content, Sendable, Equatable {
    public let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    public enum ServerError: Content, Equatable, Sendable, Error {
        case failedToGetServerResponse
    }
}

public let apiClient = URLRoutingClient.live(
    router: SiteRouter.router
        .baseURL("http://127.0.0.1:8080")
)
