import Foundation
import SwiftUI
import Tagged

public struct Boardgame: Sendable, Codable, Hashable, CustomStringConvertible, Identifiable {
    public let id: ID
    public let title: String
    public let imageURL: String
    public let details: Details
    public let category: Category
    public var description: String
}

public extension Boardgame {
    struct Details: Sendable, Codable, Hashable {
        public let publisher: String
        public let releaseOn: Date
        public let playInfo: PlayInfo
        public let players: PlayersInfo
    }
}

public extension Boardgame.Details {
    struct PlayInfo: Sendable, Codable, Hashable {
        public let duration: Int
    }
}

public extension Boardgame.Details {
    struct PlayersInfo: Sendable, Codable, Hashable {
        public let count: PlayerCount
        public let age: Int
    }
}

public extension Boardgame.Details.PlayersInfo {
    struct PlayerCount: Sendable, Codable, Hashable {
        public let min: Int
        public let max: Int
    }
}

public extension Boardgame {
    typealias ID = Tagged<Self, UUID>
}

public extension Boardgame {
    enum Category: Sendable, Hashable, Codable, CaseIterable {
        case strategy
    }
}
