import ComposableArchitecture
import Foundation
import UserModel

public struct UserDefaultsClient: Sendable {
    public var boolForKey: @Sendable (String) async -> Bool
    public var dataForKey: @Sendable (String) async -> Data?
    public var doubleForKey: @Sendable (String) async -> Double
    public var integerForKey: @Sendable (String) async -> Int
    public var stringForKey: @Sendable (String) async -> String
    public var jwtForKey: @Sendable (String) async -> String
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void
    public var setString: @Sendable (String, String) async -> Void
    public var setJWT: @Sendable (String, String) async -> Void
}

private let isLoggedInKey: String = "isLoggedInKey"
private let currencyKey: String = "currencyKey"
private let jwtKey: String = "jwtKey"

public extension UserDefaultsClient {
    func setIsLoggedIn(_ isLoggedIn: Bool) async {
        await setBool(isLoggedIn, isLoggedInKey)
    }
    
    func getIsLoggedIn() async -> Bool {
        await boolForKey(isLoggedInKey)
    }
    
    func setDefaultCurrency(_ currency: String) async {
        await setString(currency, currencyKey)
    }
    
    func getDefaultCurrency() async -> String {
        await stringForKey(currencyKey)
    }
    
    func setLoggedInUserJWT(_ jwt: String) async {
        await setJWT(jwt, jwtKey)
    }
    
    func getLoggedInUserJWT() async -> String {
        await jwtForKey(jwtKey)
    }
 
    
}


