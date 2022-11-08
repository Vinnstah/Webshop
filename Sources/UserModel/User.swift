
import Foundation
import CryptoKit

public struct User: Equatable, Codable, Sendable {
    
    public var credentials: Credentials
    
    public init(
        credentials: Credentials
    ) {
        self.credentials = credentials
    }
}

public extension User {
    struct Credentials: Equatable, Codable, Sendable {
        
        public var email: String
        public var password: String
        
        public var hashedPassword: String {
                let utf8ConvertedPassword = password.data(using: .utf8)!
                let sha256password = Data(SHA256.hash(data: utf8ConvertedPassword))
            
                return sha256password.base64EncodedString()
        }
        
        public init(
            email: String,
            password: String
        ) {
            self.email = email
            self.password = password
        }
        
    }
}

public enum ClientError: Error, Equatable {
    case failedToLogin(String)
    case failedToCreateUser(String)
}
