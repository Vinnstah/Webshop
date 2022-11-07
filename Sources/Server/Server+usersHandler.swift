import Vapor
import SiteRouter
import Foundation

func usersHandler(
    route: UserRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .create(user):
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    case let .login(user):
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    }
}
