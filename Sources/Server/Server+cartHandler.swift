import Vapor
import SiteRouter
import Foundation

func cartHandler(
    route: CartRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .session(route):
        return try await sessionHandler(route: route)
    }
}

func sessionHandler(
    route: SessionRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case let .items(route):
        return try await itemsHandler(route: route)
    case let .create(cart):
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    case .fetch(id: let id):
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    }
}

func itemsHandler(
    route: ItemRoute
) async throws -> any AsyncResponseEncodable {
    switch route {
    case .fetch:
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    case let .add(item):
        return ResultPayload(forAction: "placeholder", payload: "placerholder")
    }
}
