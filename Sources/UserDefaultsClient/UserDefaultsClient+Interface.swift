import ComposableArchitecture
import Foundation

public struct UserDefaultsClient: Sendable {
    public var boolForKey: @Sendable (String) -> Bool
    public var dataForKey: @Sendable (String) -> Data?
    public var doubleForKey: @Sendable (String) -> Double
    public var integerForKey: @Sendable (String) -> Int
    public var stringForKey: @Sendable (String) -> String
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void
    public var setString: @Sendable (String, String) async -> Void
}

private let isLoggedInKey: String = "isLoggedInKey"
private let currencyKey: String = "currencyKey"

public extension UserDefaultsClient {
    func setIsLoggedIn(_ isLoggedIn: Bool) async {
        await setBool(isLoggedIn, isLoggedInKey)
    }
    
    func getIsLoggedIn() -> Bool {
        boolForKey(isLoggedInKey)
    }
    
    func setDefaultCurrency(_ currency: String) async {
        await setString(currency, currencyKey)
    }
    
    func getDefaultCurrency() -> String {
        stringForKey(currencyKey)
    }
}
