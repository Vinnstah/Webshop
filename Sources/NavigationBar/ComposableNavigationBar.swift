//MARK: Doesn't work

//import Foundation
//import SwiftUI
//import ProductViews
//import StyleGuide
//import ComposableArchitecture
//import Product
//
//public struct ComposableNavigationBar<Action> {
//    //    public var isRoot: Bool
//    public var isCartPopulated: BoolCheck?
//    public var showCartQuickView: Button?
//    public var isFavourite: BoolCheck?
//    public var showFavouriteSymbol: Button?
//    public var showSettings: Button?
////        public var searchableBinding: Binding<String>
//    public var cancelSearch: Button?
//    public var previousScreen: Button?
//    public var showDetailView: Button?
//
//    public init(
//        //        isRoot: Bool = true,
//        isCartPopulated: BoolCheck? = nil,
//        showCartQuickView: Button? = nil,
//        isFavourite: BoolCheck? = nil,
//        showFavouriteSymbol: Button? = nil,
//        showSettings: Button? = nil
////                        , searchableBinding: Binding<String>
//        , cancelSearch: Button? = nil,
//        previousScreen: Button? = nil,
//        showDetailView: Button? = nil
//    ) {
//        //        self.isRoot = isRoot
//        self.isCartPopulated = isCartPopulated
//        self.showCartQuickView = showCartQuickView
//        self.isFavourite = isFavourite
//        self.showFavouriteSymbol = showFavouriteSymbol
//        self.showSettings = showSettings
////                self.searchableBinding = searchableBinding
//        self.cancelSearch = cancelSearch
//        self.previousScreen = previousScreen
//        self.showDetailView = showDetailView
//    }
//
//    public struct BoolCheck {
//        public let action: Action
//
//        public init(action: Action) { self.action = action }
//    }
//
//    public struct Button {
//      public let action: MenuAction?
//      public let icon: Image
//      public let title: TextState
//
//      public init(
//        title: TextState,
//        icon: Image,
//        action: MenuAction? = nil
//      ) {
//        self.action = action
//        self.icon = icon
//        self.title = title
//      }
//    }
//
//    public struct MenuAction {
//      public let action: Action
//      fileprivate let animation: Animation
//
//      fileprivate enum Animation: Equatable {
//        case inherited
//        case explicit(SwiftUI.Animation?)
//      }
//
//      public init(
//        action: Action,
//        animation: SwiftUI.Animation?
//      ) {
//        self.action = action
//        self.animation = .explicit(animation)
//      }
//
//      public init(
//        action: Action
//      ) {
//        self.action = action
//        self.animation = .inherited
//      }
//    }
//}
//
//extension ComposableNavigationBar: Equatable where Action: Equatable {}
//extension ComposableNavigationBar.Button: Equatable where Action: Equatable {}
//extension ComposableNavigationBar.BoolCheck: Equatable where Action: Equatable {}
//extension ComposableNavigationBar.MenuAction: Equatable where Action: Equatable {}
//
//extension View {
//    @MainActor public func navMenu<Action>(
//        _ store: Store<ComposableNavigationBar<Action>?, Action>
//    ) -> some View where Action: Equatable {
//        WithViewStore(store) { viewStore in
//            self.navBar(
//                item: Binding(
//                    get: {
//                        viewStore.state?.converted(
//                            send: { viewStore.send($0) },
//                            sendWithAnimation: { viewStore.send($0, animation: $1) }
//                        )
//                    },
//                    set: { state, transaction in
//                        withAnimation(transaction.disablesAnimations ? nil : transaction.animation) {
//                            if state == nil { false }
//                            }
//                        }
//                    )
//                )
//                    }
//        }
//    }
//
//extension ComposableNavigationBar {
//    fileprivate func converted(
//        send: @escaping (Action) -> Void,
//        sendWithAnimation: @escaping (Action, Animation?) -> Void
//    ) -> NavigationBar {
//        .init(
//            isRoot: false,
//                      isCartPopulated: self.isCartPopulated.map { $0.action } as! () -> Bool,
//                      showCartQuickView: self.showCartQuickView.map { $0.converted(send: send, sendWithAnimation: sendWithAnimation)},
//            isFavourite: { false },
//            showFavouriteSymbol: self.showFavouriteSymbol?.converted(send: send, sendWithAnimation: sendWithAnimation),
//            showSettings: self.showSettings?.converted(send: send, sendWithAnimation: sendWithAnimation),
//            searchableBinding: Binding(get: {String("")}, set: {_,_ in } ),
//            cancelSearch: self.cancelSearch.map { $0.converted(send: send, sendWithAnimation: sendWithAnimation) },
//            previousScreen: self.previousScreen.map { $0.converted(send: send, sendWithAnimation: sendWithAnimation)},
//            showDetailView: self.showDetailView.map { $0.converted(send: send, sendWithAnimation: sendWithAnimation)})
//    }
//}
//
//extension ComposableNavigationBar.Button {
//    fileprivate func converted(
//        send: @escaping (Action) -> Void,
//        sendWithAnimation: @escaping (Action, Animation?) -> Void
//    ) -> NavigationBar.Button {
//        .init(
//            title: Text(self.title),
//            icon: self.icon,
//            action: {
//                if let action = self.action {
//                    switch action.animation {
//                    case .inherited:
//                        send(action.action)
//                    case let .explicit(animation):
//                        sendWithAnimation(action.action, animation)
//                    }
//                }
//            })
//    }
//}
////public struct NavBar<Content: View>: SwiftUI.View {
////
////    public struct ViewState: Equatable {
////        let showDetailView: Bool
////        let searchText: String
////        let favoriteProducts: FavoriteProducts
////        let isCartEmpty: Bool
////        let product: Product
////
////
////        public init(
////            showDetailView: Bool,
////            searchText: String,
////            favoriteProducts: FavoriteProducts,
////            isCartEmpty: Bool,
////            product: Product
////        ) {
////            self.showDetailView = showDetailView
////            self.searchText = searchText
////            self.favoriteProducts = favoriteProducts
////            self.isCartEmpty = isCartEmpty
////            self.product = product
////        }
////    }
////
////    public enum ViewAction: Equatable {
////        case settingsButtonTapped
////        case toggleDetailView(Product?)
////        case searchTextReceivingInput(text: String)
////        case cancelSearchTapped
////        case addFavouriteProduct(Product.ID)
////    }
////
////    let content: Content
////    private let store: Store<ViewState, ViewAction>
////    private let viewStore: ViewStore<ViewState, ViewAction>
////    public init(
////       store: Store<ViewState, ViewAction>,
////       content: () -> Content
////    ) {
////        self.store = store
////        self.viewStore = ViewStore(self.store)
////        self.content = content()
////    }
////
//
////
////public struct NavBar<Feature: ReducerProtocol>: SwiftUI.View where Feature.State: NavigationBarState
////{
////
////    public enum ViewAction: Equatable {
////        case settingsButtonTapped
////        case toggleDetailView(Product?)
////        case searchTextReceivingInput(text: String)
////        case cancelSearchTapped
////        case addFavouriteProduct(Product.ID)
////    }
////
////    let store: StoreOf<Feature>
//////    let content: Content
////
////    public init(
////        store: StoreOf<Feature>
//////        content: () -> Content
////    ) {
////        self.store = store
//////        self.content = content()
////    }
////
////    public var body: some View {
////        WithViewStore(self.store, observe: { $0 }) { viewStore in
////            NavigationView {
////                GeometryReader { geometry in
////                    VStack {
////                        ZStack {
////                            HStack {
////                                if !viewStore.state.showDetailView {
////                                    Button(action: { viewStore.send(.settingsButtonTapped) }, label: {
////                                        Image(systemName: "gearshape")
////                                            .bold()
////                                            .padding()
////                                            .foregroundColor(Color("Secondary"))
////                                    })
////                                } else {
////                                    backButton(
////                                        action: { viewStore.send(.toggleDetailView(nil), animation: .easeOut) },
////                                        detailViewShown: viewStore.state.showDetailView )
////                                }
////
////                                Spacer()
////
////                                if !viewStore.state.showDetailView {
////                                    searchBar(
////                                        bindingText: viewStore.binding(
////                                            get: { $0.searchText },
////                                            send: { .searchTextReceivingInput(text: $0) }),
////                                        showCancel: { viewStore.state.searchText() != "" },
////                                        cancelSearch: { viewStore.send(.cancelSearchTapped, animation: .default) }
////
////                                    )
////                                }
////                                if viewStore.state.showDetailView {
////                                    favoriteButton(
////                                        action: { viewStore.send(.addFavouriteProduct(viewStore.state.product().id)) },
////                                        isFavorite:
////                                            viewStore.state.favoriteProducts().sku.contains { $0 == viewStore.state.product().id },
////                                        bgColor: Color("BackgroundColor")
////                                    )
////                                }
////
////                                ZStack{
////                                    Button(action: {
////                                        //CART
////                                    }, label: {
////                                        Image(systemName: "cart")
////                                            .padding()
////                                            .bold()
////                                            .foregroundColor(Color("Secondary"))
////                                    })
////
////                                    if !viewStore.state.isCartEmpty() {
////                                        Circle()
////                                            .foregroundColor(Color("Primary"))
////                                            .scaledToFill()
////                                            .frame(width: 10, height: 10, alignment: .topTrailing)
////                                            .offset(x: 8, y: -10)
////                                    }
////                                }
////
////                            }
////                            .frame(width: geometry.size.width)
////                            .font(.system(size: 22))
////                        }
//////                        self.content
//////                            .padding()
//////                            .cornerRadius(20)
////                    }
////                }
////                .navigationBarHidden(true)
////                .background {
////                    Color("BackgroundColor")
////                        .ignoresSafeArea()
////                }
////            }
////        }
////    }
////}
//
//
////
////import Foundation
////import SwiftUI
////import ProductViews
////import StyleGuide
////import ComposableArchitecture
////import Product
////import HomeFeature
////import FavoriteFeature
////
////public struct NavBar<Content: View>: SwiftUI.View {
////
////    let store: StoreOf<Home>
////    let content: Content
////
////    public init(
////        store: StoreOf<Home>, content: () -> Content
////    ) {
////        self.store = store
////        self.content = content()
////    }
////
////    public var body: some View {
////        WithViewStore(self.store, observe: { $0 } ) { viewStore in
////            NavigationView {
////                GeometryReader { geometry in
////                    VStack {
////                        ZStack {
////                            HStack {
////                                if !viewStore.state.showDetailView {
////                                    Button(action: { viewStore.send(.internal(.settingsButtonTapped)) }, label: {
////                                        Image(systemName: "gearshape")
////                                            .bold()
////                                            .padding()
////                                            .foregroundColor(Color("Secondary"))
////                                    })
////                                } else {
////
////                                    backButton(
////                                        action: { viewStore.send(.detailView(.toggleDetailView(nil)), animation: .easeOut) },
////                                        detailViewShown: { viewStore.state.showDetailView })
////                                }
////
////                                Spacer()
////
////                                if !viewStore.state.showDetailView {
////                                    searchBar(
////                                        bindingText: viewStore.binding(
////                                            get: { $0.searchText },
////                                            send: { .internal(.searchTextReceivingInput(text: $0)) }).animation(),
////                                        showCancel: { viewStore.state.searchText != "" },
////                                        cancelSearch: { viewStore.send(.internal(.cancelSearchTapped), animation: .default) }
////                                    )
////                                }
////                                if viewStore.state.showDetailView {
////                                    favoriteButton(
////                                        action: { viewStore.send(.favorite(.addFavouriteProduct(viewStore.state.product!.id))) },
////                                        isFavorite:
////                                            viewStore.state.favoriteProducts.sku.contains { $0 == viewStore.state.product!.id },
////                                        bgColor: Color("BackgroundColor")
////                                    )
////                                }
////
////                                ZStack{
////                                    Button(action: {
////                                        //CART
////                                    }, label: {
////                                        Image(systemName: "cart")
////                                            .padding()
////                                            .bold()
////                                            .foregroundColor(Color("Secondary"))
////                                    })
////
////                                    if viewStore.state.cart != nil {
////                                        Circle()
////                                            .foregroundColor(Color("Primary"))
////                                            .scaledToFill()
////                                            .frame(width: 10, height: 10, alignment: .topTrailing)
////                                            .offset(x: 8, y: -10)
////                                    }
////                                }
////
////                            }
////                            .frame(width: geometry.size.width)
////                            .font(.system(size: 22))
////                        }
////
////                        self.content
////                            .padding()
////                            .cornerRadius(20)
////                    }
////                }
////                .navigationBarHidden(true)
////                .background {
////                    Color("BackgroundColor")
////                        .ignoresSafeArea()
////                }
////            }
////        }
////    }
////}
//
//public struct NavigationBar {
//    public var isRoot: Bool
//    public var isCartPopulated: () -> Bool
//    public var showCartQuickView: Button?
//    public var isFavourite: () -> Bool?
//    public var showFavouriteSymbol: Button?
//    public var showSettings: Button?
//    public var searchableBinding: Binding<String>
//    public var cancelSearch: Button?
//    public var previousScreen: Button?
//    public var showDetailView: Button?
//    
//    public init(isRoot: Bool, isCartPopulated: @escaping () -> Bool, showCartQuickView: Button? = nil, isFavourite: @escaping () -> Bool?, showFavouriteSymbol: Button? = nil, showSettings: Button? = nil, searchableBinding: Binding<String>, cancelSearch: Button? = nil, previousScreen: Button? = nil, showDetailView: Button? = nil) {
//        self.isRoot = isRoot
//        self.isCartPopulated = isCartPopulated
//        self.showCartQuickView = showCartQuickView
//        self.isFavourite = isFavourite
//        self.showFavouriteSymbol = showFavouriteSymbol
//        self.showSettings = showSettings
//        self.searchableBinding = searchableBinding
//        self.cancelSearch = cancelSearch
//        self.previousScreen = previousScreen
//        self.showDetailView = showDetailView
//    }
//    
//    public struct Button: Identifiable {
//        public let action: () -> Void
//        public let icon: Image
//        public let id: UUID
//        public let title: Text
//        
//        public init(
//            title: Text,
//            icon: Image,
//            action: @escaping () -> Void = {}
//        ) {
//            self.action = action
//            self.icon = icon
//            self.id = UUID()
//            self.title = title
//        }
//    }
//}
//
//private struct NavigationBarWrapper<Content: SwiftUI.View>: SwiftUI.View {
//    let content: Content
//    @Binding var item: NavigationBar?
//    
//    public var body: some SwiftUI.View {
//                VStack {
//                    ZStack {
//                        HStack {
//                            if item?.showSettings != nil {
//                            settingsButton(action: { item?.showSettings?.action() } )
//                                
//                            }
//                            else {
//                                backButton(
//                                    action: { item?.previousScreen?.action() }
//                                    )
//                            }
////
//                            Spacer()
//                            
//                            //                                if !viewStore.state.showDetailView {
//                            //
//                            //                                    SearchBar(
//                            //                                        bindingText: viewStore.binding(
//                            //                                            get: { $0.searchText },
//                            //                                            send: { .internal(.searchTextReceivingInput(text: $0)) } ),
//                            //                                        showCancel: { viewStore.state.searchText != "" },
//                            //                                        cancelSearch: { viewStore.send(.internal(.cancelSearchTapped)) }
//                            //                                    )
//                            //                                }
//                            //
//                            //                                if viewStore.state.showDetailView {
//                            //                                    favoriteButton(
//                            //                                        action: { viewStore.send(.internal(.addFavouriteProduct(Product.ID(rawValue: (viewStore.state.product?.id)!.rawValue) ))) },
//                            //                                        isFavorite:
//                            //                                            viewStore.state.favoriteProducts?.sku.contains { $0 == viewStore.state.product?.id },
//                            //                                        bgColor: Color("BackgroundColor")
//                            //                                    )
//                            //                                }
//                            //
//                            //                                cartButton(buttonAction: {}, isCartEmpty: { viewStore.state.isCartEmpty })
//                        }
//                        
////                        .frame(width: .in)
//                        .font(.system(size: 22))
//                    }
//                    
//                    self.content
//                        .padding()
//                        .cornerRadius(20)
//                }
////                .background {
////                    Color("BackgroundColor")
////                        .ignoresSafeArea()
////                }
//            }
//        }
//
//
//extension View {
//    public func navBar(
//        item: Binding<NavigationBar?>
//    ) -> some View {
//        NavigationBarWrapper(content: self, item: item)
//    }
//}
