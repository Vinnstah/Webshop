import Foundation

public struct JWT: Codable, Sendable, Equatable {
    
    let header: Header
    let payload: Payload
    
    public init(header: Header, payload: Payload) {
        self.header = header
        self.payload = payload
    }
}

public extension JWT {
    
    struct Header: Codable, Equatable, Sendable {
        public var alg: String
        public var typ: String
        
        public init(
            alg: String = "HS256",
            typ: String = "JWT"
        ) {
            self.alg = alg
            self.typ = typ
        }
    }
}
    
public extension JWT {
     struct Payload: Codable, Equatable, Sendable {
        public var sub: String
        public let name: String
        public var iat: Double
        
        public init(
            sub: String = UUID().uuidString,
            name: String,
            iat: Double = Date().timeIntervalSince1970
        ) {
            self.sub = sub
            self.name = name
            self.iat = iat
        }
    }
}

