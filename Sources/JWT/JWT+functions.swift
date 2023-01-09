import Foundation
import CryptoKit
import JSONClients
import Dependencies

public func constructJWT(secretKey: String, header: JWT.Header, payload: JWT.Payload) -> String {
    
    @Dependency(\.jsonEncoder) var jsonEncoder
    
    let secret = secretKey
    let privateKey = SymmetricKey(data: Data(secret.utf8))
    let headerJSONData = try! jsonEncoder().encode(header)
    let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
    
    let payloadJSONData = try! jsonEncoder().encode(payload)
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
