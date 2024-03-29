import Foundation

public struct ResultPayload<Payload: Sendable & Equatable & Codable>: Codable, Sendable, Equatable {
    public let forAction: String
    public let payload: Payload?
    public var status: Result<Payload, Failure> {
        guard let payload else {
            return .failure(.failure)
        }
        return .success(payload)
    }
    
    public init(forAction: String, payload: Payload?) {
        self.forAction = forAction
        self.payload = payload
    }
    

    public enum Failure: String, Error, Sendable, Codable {
        case failure
    }
}


public struct CreateUserResponse: Codable, Equatable {
    let email: String
    let jwt: String
    let status: String
    
    public init(email: String, jwt: String, status: String) {
        self.email = email
        self.jwt = jwt
        self.status = status
    }
}
