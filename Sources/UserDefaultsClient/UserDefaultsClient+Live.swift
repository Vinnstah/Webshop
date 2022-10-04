import Foundation
import ComposableArchitecture
import UserModel

extension UserDefaultsClient {
    public static func live(
        userDefaults: @Sendable @autoclosure @escaping () -> UserDefaults = UserDefaults(
            suiteName: "group.webshop"
        )!
    ) -> Self {
        Self(
            boolForKey: { userDefaults().bool(forKey: $0) },
            dataForKey: { userDefaults().data(forKey: $0) },
            doubleForKey: { userDefaults().double(forKey: $0) },
            integerForKey: { userDefaults().integer(forKey: $0) },
            stringForKey: { userDefaults().string(forKey: $0) ?? "" },
            userForKey: {
                let data = userDefaults().data(forKey: $0)
                return try! PropertyListDecoder().decode(User.self, from: data!)
            },
            remove: { userDefaults().removeObject(forKey: $0) },
            setBool: { userDefaults().set($0, forKey: $1) },
            setData: { userDefaults().set($0, forKey: $1) },
            setDouble: { userDefaults().set($0, forKey: $1) },
            setInteger: { userDefaults().set($0, forKey: $1) },
            setString: { userDefaults().set($0, forKey: $1) },
            setUser: { userDefaults().set(try? PropertyListEncoder().encode($0), forKey: $1) }
        )
    }
}

private enum UserDefaultsClientKey: DependencyKey {
    typealias Value = UserDefaultsClient
    static let liveValue = UserDefaultsClient.live()
    static let testValue = UserDefaultsClient.unimplemented
}
public extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClientKey.self] }
        set { self[UserDefaultsClientKey.self] = newValue }
    }
}
