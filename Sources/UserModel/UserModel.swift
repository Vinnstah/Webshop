//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-29.
//

import Foundation
import Vapor
//import PostgresNIO

// TODO: Separate userSettings
public struct User: Content, Equatable, Codable, Sendable {
    public var email: String
    public var password: String
    public var jwt: String
    public var userSettings: UserSettings
    
    public var hexedPassword: String {
        let utf8ConvertedPassword = password.data(using: .utf8)!
        let sha256password = Data(SHA256.hash(data: utf8ConvertedPassword))
        return sha256password.base64EncodedString()
    }
    
    public init(
        email: String,
        password: String,
        jwt: String,
        userSettings: UserSettings
    ) {
        self.email = email
        self.password = password
        self.jwt = jwt
        self.userSettings = userSettings
    }
    
    public struct UserSettings: Content, Equatable, Sendable {
        public var defaultCurrency: Currency
        
        public init(defaultCurrency: Currency = .SEK) {
            self.defaultCurrency = defaultCurrency
        }
    }
}

//TODO: Implement User model with local settings.
/// Not sure where to place this. Should maybe be part of a User model with other local settings.
public enum Currency: String, Equatable, Sendable, CaseIterable, Codable {
    case SEK = "SEK"
    case USD = "USD"

    
    public init(_ rawValue: String) {
        self = Currency(rawValue: rawValue) ?? .SEK
    }
}