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
    public var stringForArrayKey: @Sendable (String) async -> [String]
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void
    public var setString: @Sendable (String, String) async -> Void
    public var setJWT: @Sendable (String, String) async -> Void
    public var setArray: @Sendable ([String], String) async -> Void
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
    
    func setFavoriteProduct(_ sku: String) async {
        var skus = await stringForArrayKey(favoriteKey)
        skus.append(sku)
        await setArray(skus, favoriteKey)
    }
    
    func getFavoriteProducts() async -> [String?] {
        await stringForArrayKey(favoriteKey)
    }
    
    func removeFavoriteProduct(_ sku: String, favoriteProducts: [String?]) async {
        await remove(favoriteKey)
        
        let modifiedArrayOfFavorites = favoriteProducts.filter( { $0 != sku } )
        print(modifiedArrayOfFavorites)
        for prod in modifiedArrayOfFavorites {
            print(prod)
            await setFavoriteProduct(prod!)
        }
           
    }
 
    
}


