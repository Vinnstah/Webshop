//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-29.
//

import Foundation
import ComposableArchitecture
import VaporRouting
import SiteRouter

private enum URLRoutingClientKey: DependencyKey {
    typealias Value = URLRoutingClient
    static let liveValue = URLRoutingClient.live(router: SiteRouter.router
        .baseURL("http://127.0.0.1:8080"))
    static let testValue = URLRoutingClient.live(router: SiteRouter.router
        .baseURL("http://127.0.0.1:8080"))
}
public extension DependencyValues {
    var urlRoutingClient: URLRoutingClient<SiteRoute> {
        get { self[URLRoutingClientKey.self] }
        set { self[URLRoutingClientKey.self] = newValue }
    }
}

extension URLRoutingClient: @unchecked Sendable {}
