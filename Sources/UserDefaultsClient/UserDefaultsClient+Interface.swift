import ComposableArchitecture
import Foundation

public struct UserDefaultsClient: Sendable {
    public var boolForKey: @Sendable (String) -> Bool
    public var dataForKey: @Sendable (String) -> Data?
    public var doubleForKey: @Sendable (String) -> Double
    public var integerForKey: @Sendable (String) -> Int
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void
}

private let isLoggedInKey: String = "isLoggedInKey"

public extension UserDefaultsClient {
    func setIsLoggedIn(_ isLoggedIn: Bool) async {
        await setBool(isLoggedIn, isLoggedInKey)
    }
    
    func getIsLoggedIn() -> Bool {
        boolForKey(isLoggedInKey)
    }
}
