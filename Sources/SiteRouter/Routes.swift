import URLRouting
import ComposableArchitecture
import UserModel
import CartModel
import Warehouse
import Product

public enum SiteRoute: Equatable {
    case users(UserRoute)
    case cart(CartRoute)
    case warehouse(WarehouseRoute)
    case boardgame(BoardgameRoute)
}

public enum UserRoute: Equatable {
    case create(User)
    case login(User)
}

public enum CartRoute: Equatable {
    case create(Cart)
    case fetch(id: String)
    case add(item: Cart.Item)
    case fetchItems
}

public enum WarehouseRoute: Equatable {
    case fetch
    case get(id: String)
    case update(Warehouse.Item)
}

public enum BoardgameRoute: Equatable {
    case fetch
}


