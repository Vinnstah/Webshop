//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-29.
//

import Foundation
import Vapor

/// Secret should not be a part of this model
public struct UserModel: Content, Equatable, Codable, Sendable {
    public let username: String
    public let password: String
    public let token: String
    public let secret: String
    
    public init(
        username: String,
        password: String,
        token: String,
        secret: String
    ) {
        self.username = username
        self.password = password
        self.token = token
        self.secret = secret
    }
}
