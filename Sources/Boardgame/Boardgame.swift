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
        public let descriptionText: String
    }
}

public extension Boardgame.Details {
    struct PlayersInfo: Sendable, Codable, Hashable {
        public let age: Int
        public let count: PlayerCount
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
    enum Category: String, Sendable, Hashable, Codable, CaseIterable {
        public typealias RawValue = String
        
        case strategy = "Strategy"
        case classics = "Classics"
        case children = "Children"
        case scifi = "Sci-fi"
        
        public init?(rawValue: RawValue) {
            switch rawValue {
            case "Strategy": self = .strategy
            case "Classics": self = .classics
            case "Children": self = .children
            case "Sci-fi": self = .scifi
            default:
                self = .scifi
            }
        }

        
    }
}
