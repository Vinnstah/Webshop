import Foundation
import URLRouting
import UserModel
import CartModel
import Warehouse
import Product

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
    Route(.case(CartRoute.create)) {
        Path { "cart" }
        Method.post
        Body(.json(Cart.self))
    }

    Route(.case(CartRoute.fetch(id:))) {
        Path { "cart" }
        Query {
            Field("id")
        }
    }
    
    Route(.case(CartRoute.fetchItems)) {
        Path { "cart"; "item" }
    }
    
    Route(.case(CartRoute.add(item:))) {
        Path { "cart"; "item" }
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
    
    Route(.case(WarehouseRoute.get(id: ))) {
        Path { "warehouse" }
        Query {
            Field("id")
        }
    }
}
