import Foundation
import ComposableArchitecture
import URLRouting
import SiteRouter

private enum ApiClientKey: DependencyKey {
    typealias Value = URLRoutingClient
    static let liveValue = URLRoutingClient.live(router: SiteRouter.router
        .baseURL("http://127.0.0.1:8080"))
    static let testValue = URLRoutingClient.live(router: SiteRouter.router
        .baseURL("http://127.0.0.1:8080"))
}
public extension DependencyValues {
    var apiClient: URLRoutingClient<SiteRoute> {
        get { self[ApiClientKey.self] }
        set { self[ApiClientKey.self] = newValue }
    }
}

extension URLRoutingClient: @unchecked Sendable {}
