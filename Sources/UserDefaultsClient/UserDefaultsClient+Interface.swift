import ComposableArchitecture
import Foundation
import UserModel
import ProductModel

public struct UserDefaultsClient: Sendable {
    public var boolForKey: @Sendable (String) async -> Bool
    public var dataForKey: @Sendable (String) async -> Data?
    public var doubleForKey: @Sendable (String) async -> Double
    public var integerForKey: @Sendable (String) async -> Int
    public var stringForKey: @Sendable (String) async -> String
    public var jwtForKey: @Sendable (String) async -> String
    public var stringForArrayKey: @Sendable (String) async -> [Product.SKU]
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void
    public var setString: @Sendable (String, String) async -> Void
    public var setJWT: @Sendable (String, String) async -> Void
    public var setArray: @Sendable ([Product.SKU], String) async -> Void
}

private let currencyKey: String = "currencyKey"
private let jwtKey: String = "jwtKey"
private let favoriteKey: String = "favoriteKey"

public extension UserDefaultsClient {
    
    func setDefaultCurrency(_ currency: String) async {
        await setString(currency, currencyKey)
    }
    
    func getDefaultCurrency() async -> String {
        await stringForKey(currencyKey)
    }
    
    func setLoggedInUserJWT(_ jwt: String) async {
        await setString(jwt, jwtKey)
    }
    
    func getLoggedInUserJWT() async -> String? {
        guard !(await stringForKey(jwtKey)).isEmpty else {
            return nil
        }
       return await stringForKey(jwtKey)
    }
    
    func removeLoggedInUserJWT() async -> Void {
        await remove(jwtKey)
    }
    
    func setFavoriteProduct(_ sku: Product.SKU) async {
        var skus = await stringForArrayKey(favoriteKey)
        skus.append(sku)
        await setArray(skus, favoriteKey)
    }
    
    func getFavoriteProducts() async -> [Product.SKU?] {
        await stringForArrayKey(favoriteKey)
    }
    
    func removeFavoriteProduct(_ sku: Product.SKU, favoriteProducts: [Product.SKU?]) async {
        await remove(favoriteKey)
        
        for prod in favoriteProducts where prod != sku {
            await setFavoriteProduct(prod!)
        }
    }
}


