import Foundation
import Dependencies
import URLRouting
import SiteRouter

extension URLRoutingClient<SiteRoute>: DependencyKey {
    public static let liveValue = URLRoutingClient.live(router: SiteRouter.router
        .baseURL("http://127.0.0.1:8080"))
}

public extension DependencyValues {
    var apiClient: URLRoutingClient<SiteRoute> {
        get { self[URLRoutingClient.self] }
        set { self[URLRoutingClient.self] = newValue }
    }
}
// MARK: - URLRoutingClient + Sendable
extension URLRoutingClient: @unchecked Sendable {}

