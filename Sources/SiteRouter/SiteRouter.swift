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

//public let apiClient = URLRoutingClient.live(
//    router: SiteRouter.router
//        .baseURL("http://127.0.0.1:8080")
//)
//
//private enum URLRoutingClientKey: DependencyKey {
//    typealias Value = URLRoutingClient
//    static let liveValue = URLRoutingClient.live(router: SiteRouter.router
//        .baseURL("http://127.0.0.1:8080"))
//    static let testValue = URLRoutingClient.live(router: SiteRouter.router
//        .baseURL("http://127.0.0.1:8080"))
//}
//public extension DependencyValues {
//    var urlRoutingClient: URLRoutingClient<SiteRoute> {
//        get { self[URLRoutingClientKey.self] }
//        set { self[URLRoutingClientKey.self] = newValue }
//    }
//}
//
//extension URLRoutingClient: @unchecked Sendable {}
