import Foundation
import Dependencies
import URLRouting
import SiteRouter

#if DEBUG
import XCTestDynamicOverlay
extension URLRoutingClient<SiteRoute>: TestDependencyKey {
       public static let testValue = URLRoutingClient.live(router: SiteRouter.router
            .baseURL("http://127.0.0.1:8080"))
}
#endif
