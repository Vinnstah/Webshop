//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-28.
//

import Foundation
import CryptoKit

public struct JWT: Codable, Sendable, Equatable {
    
    let header: Header
    let payload: Payload
    
    public init(header: Header, payload: Payload) {
        self.header = header
        self.payload = payload
    }
    
    public struct Header: Codable, Equatable, Sendable {
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
    
    public struct Payload: Codable, Equatable, Sendable {
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

public func constructJWT(secretKey: String, header: JWT.Header, payload: JWT.Payload) -> String {
    let secret = secretKey
    let privateKey = SymmetricKey(data: Data(secret.utf8))
    let headerJSONData = try! JSONEncoder().encode(header)
    let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
    
    let payloadJSONData = try! JSONEncoder().encode(payload)
    let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()
    
    let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)
    
    let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: privateKey)
    let signatureBase64String = Data(signature).urlSafeBase64EncodedString()
    
    let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
    return token
//    return ["token": token]
}


extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
