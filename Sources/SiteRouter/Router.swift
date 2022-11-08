import Foundation
import URLRouting
import UserModel
import CartModel
import Warehouse

public let router = OneOf {
    
    Route(.case(SiteRoute.boardgame(.fetch))) {
        Path { "boardgame" }
    }
    
    Route(.case(SiteRoute.users)) {
        userRouter
    }
    
    Route(.case(SiteRoute.cart)) {
        cartRouter
    }
    
    Route(.case(SiteRoute.warehouse)) {
        warehouseRouter
    }
}

public let userRouter = OneOf {
    Route(.case(UserRoute.create)) {
        Path { "users" }
        Method.post
        Body(.json(User.self))
    }
    
    Route(.case(UserRoute.login)) {
        Path { "users"; "login" }
        Method.post
        Body(.json(User.self))
    }
}

public let cartRouter = OneOf {
    Route(.case(CartRoute.session)) {
        sessionRouter
    }
}

public let sessionRouter = OneOf {
    Route(.case(SessionRoute.create)) {
        Path { "cart/session" }
        Method.post
        Body(.json(Cart.self))
    }

    Route(.case(SessionRoute.fetch(id:))) {
        Path { "cart/session" }
        Query {
            Field("id")
        }
    }
    
    Route(.case(SessionRoute.items)) {
        itemRouter
    }
}

public let itemRouter = OneOf {
    Route(.case(ItemRoute.fetch)) {
        Path { "cart/session/item" }
    }
    
    Route(.case(ItemRoute.add)) {
        Path { "cart/session/item" }
        Method.post
        Body(.json(Cart.Item.self))
    }
}

public let warehouseRouter = OneOf {
    Route(.case(WarehouseRoute.fetch)) {
        Path { "warehouse" }
    }
    
    Route(.case(WarehouseRoute.update)) {
        Path { "warehouse" }
        Method.post
        Body(.json(Warehouse.Item.self))
    }
}
