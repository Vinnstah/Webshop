import URLRouting
import ComposableArchitecture
import UserModel
import CartModel
import Warehouse
import Product
import Foundation

public enum SiteRoute: Equatable {
    case users(UserRoute)
    case cart(CartRoute)
    case warehouse(WarehouseRoute)
    case boardgame(BoardgameRoute)
    case products(ProductRoute)
}

public enum UserRoute: Equatable {
    case create(User)
    case login(User)
}

public enum CartRoute: Equatable {
    case create(jwt: Cart.Session.JWT.RawValue)
    case fetch(jwt: String)
    case fetchAllItems(session: UUID)
    case add(item: Cart)
    case delete(id: Cart.Session.ID.RawValue, product: Product.ID.RawValue)
}

public enum WarehouseRoute: Equatable {
    case fetch
    case get(id: String)
    case update(Warehouse.Item)
}

public enum BoardgameRoute: Equatable {
    case fetch
}

public enum ProductRoute: Equatable {
    case fetch
}

