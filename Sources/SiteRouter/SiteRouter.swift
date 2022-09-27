import Vapor
import VaporRouting
import CryptoKit

public enum SiteRoute: Equatable {
    case api(LoginRoute)
}

public enum LoginRoute: Equatable {
    case login(UserModel)
}

public let router = OneOf {
    Route(.case(SiteRoute.api)) {
        Path { "api" }
        loginRouter
    }
}

public let loginRouter = OneOf {
    Route(.case(LoginRoute.login)) {
        Method.post
        Body(.json(UserModel.self))
    }
}

/// Secret should not be a part of this model
public struct UserModel: Equatable, Codable, Sendable {
    public let username: String
    public let password: String
    public let secret: String
    
    public init(
        username: String,
        password: String,
        secret: String
    ) {
        self.username = username
        self.password = password
        self.secret = secret
    }
}

public struct LoginResponse: Codable, Content {
    public let jwt: JWT
}

public struct JWT: Codable {
    let header: Header
    let payload: Payload
    
    public struct Header: Codable {
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
    
    public struct Payload: Codable {
        public var sub: String
        public let name: String
        public var iat: Double
        
        public init(
            sub: String = UUID().uuidString,
            name: String,
            iat: Double = NSDate().timeIntervalSince1970
        ) {
            self.sub = sub
            self.name = name
            self.iat = iat
        }
    }
    
    public init(header: Header, payload: Payload) {
        self.header = header
        self.payload = payload
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
}


extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

public let apiClient = URLRoutingClient.live(
    router: SiteRouter.router
      .baseURL("http://127.0.0.1:8080")
  )
