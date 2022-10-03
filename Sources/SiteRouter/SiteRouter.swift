import Vapor
import VaporRouting
import ComposableArchitecture
import UserModel


public enum SiteRoute: Equatable {
    case login(User)
    case retrieveSecret(Secret)
}


public let router = OneOf {
    Route(.case(SiteRoute.login)) {
        Path { "login" }
        Method.post
        Body(.json(User.self))
    }
    Route(.case(SiteRoute.retrieveSecret)) {
        Path { "secret" }
        Method.post
        Body(.json(Secret.self))
    }
}

public struct Secret: Codable, Equatable {
    public let passcode: String
    
    public init(passcode: String) {
        self.passcode = passcode
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
