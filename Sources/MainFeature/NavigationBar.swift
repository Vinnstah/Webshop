import Foundation
import SwiftUI
import ProductViews
import StyleGuide
import ComposableArchitecture
import Product
import HomeFeature
import FavoriteFeature

public extension Main {
    struct NavigationBar<Content: SwiftUI.View>: SwiftUI.View {
        
        
        public let store: StoreOf<Main>
        public let content: Content
        
        public init(store: StoreOf<Main>,content: () -> Content) {
            self.store = store
            self.content = content()
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: \.internalState ) { viewStore in
                NavigationView {
                    GeometryReader { geometry in
                        VStack {
                            ZStack {
                                HStack {
                                    if !viewStore.state.showDetailView {
                                        settingsButton(action: { viewStore.send(.internal(.settingsButtonTapped)) })

                                    }
                                    else {
                                        backButton(
                                            action: { viewStore.send(.internal(.toggleDetailView(nil)), animation: .easeOut) },
                                            detailViewShown: { viewStore.state.showDetailView } )
                                    }
                                    
                                    Spacer()
                                    
                                    if !viewStore.state.showDetailView {

                                        SearchBar(
                                            bindingText: viewStore.binding(
                                                get: { $0.searchText },
                                                send: { .internal(.searchTextReceivingInput(text: $0)) } ),
                                            showCancel: { viewStore.state.searchText != "" },
                                            cancelSearch: { viewStore.send(.internal(.cancelSearchTapped)) }
                                        )
                                    }
                                    
                                    if viewStore.state.showDetailView {
                                        favoriteButton(
                                            action: { viewStore.send(.internal(.addFavouriteProduct(Product.ID(rawValue: (viewStore.state.product?.id)!.rawValue) ))) },
                                            isFavorite:
                                                viewStore.state.favoriteProducts?.sku.contains { $0 == viewStore.state.product?.id },
                                            bgColor: Color("BackgroundColor")
                                        )
                                    }
                                    
                                    cartButton(buttonAction: {}, isCartEmpty: { viewStore.state.isCartEmpty })
                                }
                                
                                .frame(width: geometry.size.width)
                                .font(.system(size: 22))
                            }
                           
                            self.content
                                .padding()
                                .cornerRadius(20)
                        }
                    }
                    .navigationBarHidden(true)
                    .background {
                        Color("BackgroundColor")
                            .ignoresSafeArea()
                    }
                }
            }
        }
    }
}


//public struct NavBar<Content: View>: SwiftUI.View {
//
//    public struct ViewState: Equatable {
//        let showDetailView: Bool
//        let searchText: String
//        let favoriteProducts: FavoriteProducts
//        let isCartEmpty: Bool
//        let product: Product
//
//
//        public init(
//            showDetailView: Bool,
//            searchText: String,
//            favoriteProducts: FavoriteProducts,
//            isCartEmpty: Bool,
//            product: Product
//        ) {
//            self.showDetailView = showDetailView
//            self.searchText = searchText
//            self.favoriteProducts = favoriteProducts
//            self.isCartEmpty = isCartEmpty
//            self.product = product
//        }
//    }
//
//    public enum ViewAction: Equatable {
//        case settingsButtonTapped
//        case toggleDetailView(Product?)
//        case searchTextReceivingInput(text: String)
//        case cancelSearchTapped
//        case addFavouriteProduct(Product.ID)
//    }
//
//    let content: Content
//    private let store: Store<ViewState, ViewAction>
//    private let viewStore: ViewStore<ViewState, ViewAction>
//    public init(
//       store: Store<ViewState, ViewAction>,
//       content: () -> Content
//    ) {
//        self.store = store
//        self.viewStore = ViewStore(self.store)
//        self.content = content()
//    }
//

//
//public struct NavBar<Feature: ReducerProtocol>: SwiftUI.View where Feature.State: NavigationBarState
//{
//
//    public enum ViewAction: Equatable {
//        case settingsButtonTapped
//        case toggleDetailView(Product?)
//        case searchTextReceivingInput(text: String)
//        case cancelSearchTapped
//        case addFavouriteProduct(Product.ID)
//    }
//
//    let store: StoreOf<Feature>
////    let content: Content
//
//    public init(
//        store: StoreOf<Feature>
////        content: () -> Content
//    ) {
//        self.store = store
////        self.content = content()
//    }
//
//    public var body: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
//            NavigationView {
//                GeometryReader { geometry in
//                    VStack {
//                        ZStack {
//                            HStack {
//                                if !viewStore.state.showDetailView {
//                                    Button(action: { viewStore.send(.settingsButtonTapped) }, label: {
//                                        Image(systemName: "gearshape")
//                                            .bold()
//                                            .padding()
//                                            .foregroundColor(Color("Secondary"))
//                                    })
//                                } else {
//                                    backButton(
//                                        action: { viewStore.send(.toggleDetailView(nil), animation: .easeOut) },
//                                        detailViewShown: viewStore.state.showDetailView )
//                                }
//
//                                Spacer()
//
//                                if !viewStore.state.showDetailView {
//                                    searchBar(
//                                        bindingText: viewStore.binding(
//                                            get: { $0.searchText },
//                                            send: { .searchTextReceivingInput(text: $0) }),
//                                        showCancel: { viewStore.state.searchText() != "" },
//                                        cancelSearch: { viewStore.send(.cancelSearchTapped, animation: .default) }
//
//                                    )
//                                }
//                                if viewStore.state.showDetailView {
//                                    favoriteButton(
//                                        action: { viewStore.send(.addFavouriteProduct(viewStore.state.product().id)) },
//                                        isFavorite:
//                                            viewStore.state.favoriteProducts().sku.contains { $0 == viewStore.state.product().id },
//                                        bgColor: Color("BackgroundColor")
//                                    )
//                                }
//
//                                ZStack{
//                                    Button(action: {
//                                        //CART
//                                    }, label: {
//                                        Image(systemName: "cart")
//                                            .padding()
//                                            .bold()
//                                            .foregroundColor(Color("Secondary"))
//                                    })
//
//                                    if !viewStore.state.isCartEmpty() {
//                                        Circle()
//                                            .foregroundColor(Color("Primary"))
//                                            .scaledToFill()
//                                            .frame(width: 10, height: 10, alignment: .topTrailing)
//                                            .offset(x: 8, y: -10)
//                                    }
//                                }
//
//                            }
//                            .frame(width: geometry.size.width)
//                            .font(.system(size: 22))
//                        }
////                        self.content
////                            .padding()
////                            .cornerRadius(20)
//                    }
//                }
//                .navigationBarHidden(true)
//                .background {
//                    Color("BackgroundColor")
//                        .ignoresSafeArea()
//                }
//            }
//        }
//    }
//}


//
//import Foundation
//import SwiftUI
//import ProductViews
//import StyleGuide
//import ComposableArchitecture
//import Product
//import HomeFeature
//import FavoriteFeature
//
//public struct NavBar<Content: View>: SwiftUI.View {
//
//    let store: StoreOf<Home>
//    let content: Content
//
//    public init(
//        store: StoreOf<Home>, content: () -> Content
//    ) {
//        self.store = store
//        self.content = content()
//    }
//
//    public var body: some View {
//        WithViewStore(self.store, observe: { $0 } ) { viewStore in
//            NavigationView {
//                GeometryReader { geometry in
//                    VStack {
//                        ZStack {
//                            HStack {
//                                if !viewStore.state.showDetailView {
//                                    Button(action: { viewStore.send(.internal(.settingsButtonTapped)) }, label: {
//                                        Image(systemName: "gearshape")
//                                            .bold()
//                                            .padding()
//                                            .foregroundColor(Color("Secondary"))
//                                    })
//                                } else {
//
//                                    backButton(
//                                        action: { viewStore.send(.detailView(.toggleDetailView(nil)), animation: .easeOut) },
//                                        detailViewShown: { viewStore.state.showDetailView })
//                                }
//
//                                Spacer()
//
//                                if !viewStore.state.showDetailView {
//                                    searchBar(
//                                        bindingText: viewStore.binding(
//                                            get: { $0.searchText },
//                                            send: { .internal(.searchTextReceivingInput(text: $0)) }).animation(),
//                                        showCancel: { viewStore.state.searchText != "" },
//                                        cancelSearch: { viewStore.send(.internal(.cancelSearchTapped), animation: .default) }
//                                    )
//                                }
//                                if viewStore.state.showDetailView {
//                                    favoriteButton(
//                                        action: { viewStore.send(.favorite(.addFavouriteProduct(viewStore.state.product!.id))) },
//                                        isFavorite:
//                                            viewStore.state.favoriteProducts.sku.contains { $0 == viewStore.state.product!.id },
//                                        bgColor: Color("BackgroundColor")
//                                    )
//                                }
//
//                                ZStack{
//                                    Button(action: {
//                                        //CART
//                                    }, label: {
//                                        Image(systemName: "cart")
//                                            .padding()
//                                            .bold()
//                                            .foregroundColor(Color("Secondary"))
//                                    })
//
//                                    if viewStore.state.cart != nil {
//                                        Circle()
//                                            .foregroundColor(Color("Primary"))
//                                            .scaledToFill()
//                                            .frame(width: 10, height: 10, alignment: .topTrailing)
//                                            .offset(x: 8, y: -10)
//                                    }
//                                }
//
//                            }
//                            .frame(width: geometry.size.width)
//                            .font(.system(size: 22))
//                        }
//
//                        self.content
//                            .padding()
//                            .cornerRadius(20)
//                    }
//                }
//                .navigationBarHidden(true)
//                .background {
//                    Color("BackgroundColor")
//                        .ignoresSafeArea()
//                }
//            }
//        }
//    }
//}
