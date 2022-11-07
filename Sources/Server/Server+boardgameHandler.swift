import Vapor
import SiteRouter
import Foundation

func boardgameHandler(
    route: BoardgameRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case .fetch:
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    }
}
