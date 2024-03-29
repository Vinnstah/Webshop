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
    Route(.case(SiteRoute.products)) {
        productRouter
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
        Body(.json(Cart.Session.JWT.RawValue.self))
    }

    Route(.case(CartRoute.fetch(jwt:))) {
        Path { "cart" }
        Query {
            Field("jwt")
        }
    }
    Route(.case(CartRoute.fetchAllItems(session:))) {
        Path { "cart" ; UUID.parser() }
    }
    
    Route(.case(CartRoute.add(item:))) {
        Path { "cart"; "item" }
        Method.post
        Body(.json(Cart.self))
    }
    Route(.case(CartRoute.delete)) {
        Path { "cart" ; "item" ; "delete" ; UUID.parser() ; UUID.parser() }
        Method.delete
//        Body(.json(Product.self))
//        Query {
//            Field("ID")
//        }
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

public let productRouter = OneOf {
    Route(.case(ProductRoute.fetch)) {
        Path { "products" }
    }
}
