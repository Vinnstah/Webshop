import ComposableArchitecture
import Foundation
import UserModel

public struct UserDefaultsClient: Sendable {
    public var boolForKey: @Sendable (String) async -> Bool
    public var dataForKey: @Sendable (String) async -> Data?
    public var doubleForKey: @Sendable (String) async -> Double
    public var integerForKey: @Sendable (String) async -> Int
    public var stringForKey: @Sendable (String) async -> String
    public var userForKey: @Sendable (String) async -> User
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void
    public var setString: @Sendable (String, String) async -> Void
    public var setUser: @Sendable (User, String) async -> Void
}

private let isLoggedInKey: String = "isLoggedInKey"
private let currencyKey: String = "currencyKey"
private let userKey: String = "userKey"

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
    
    func setLoggedInUser(_ user: User) async {
        await setUser(user, userKey)
    }
    
    func getLoggedInUser() async -> User {
        await userForKey(userKey)
    }
 
    
}


