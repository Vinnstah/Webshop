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
    case create(Cart)
    case fetch(jwt: String)
    case fetchAllItems(session: UUID)
    case add(item: Cart)
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

