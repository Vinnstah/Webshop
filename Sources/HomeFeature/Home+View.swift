import Foundation
import SwiftUI
import ComposableArchitecture
import Product
import StyleGuide
import ProductViews
import CheckoutFeature
import CartModel
import NavigationBar
import Boardgame
import BrowseFeature

public extension Home {
    struct View: SwiftUI.View {
        @Namespace var animation
        public let store: StoreOf<Home>
        
        public init(
            store: StoreOf<Home>
        ) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 } ) { viewStore in
                VStack {
                    SearchBar(
                        bindingText: viewStore.binding(
                                        get: { $0.searchText },
                                        send: { .internal(.searchTextReceivingInput(text: $0)) }
                                    ),
                        showCancel: { viewStore.state.searchText != "" },
                        cancelSearch: { viewStore.send(.internal(.cancelSearchTapped),animation: .default) }
                    )
                    
                    Browse.View(store: self.store.scope(state: \.browse, action: Home.Action.browse))
                        .onAppear {
                            viewStore.send(.internal(.onAppear))
                        }
                        .refreshable {
                            viewStore.send(.internal(.onAppear))
                        }
                        .sheet(isPresented:
                                viewStore.binding(
                                    get: \.isSettingsSheetPresented,
                                    send: .internal(.settingsButtonTapped))
                        ) {
                            Settings() {
                                viewStore.send(.internal(.signOutTapped))
                            }
                            .presentationDetents([.fraction(0.1)])
                        }
                }
                .overlay(alignment: .top, content: {
                    HStack {
                        Spacer()
                        
                        viewStore.state.showCheckoutQuickView ?
                        CheckoutQuickView(
                            store: self.store)
                        : nil
                    }
                }
                )
                .onChange(of: viewStore.state.cart) { newValue in
                    viewStore.send(.task)
                }
//                .onChange(of: viewStore.state.searchText) { _ in
//                    viewStore.send(.task)
//                }
                .task {
                    viewStore.send(.task)
                }
                .searchable(text:
                                viewStore.binding(
                                    get: \.searchText,
                                    send: { .internal(.searchTextReceivingInput(text: $0)) }
                                )
                )
            }
        }
    }
}
public extension Home.View {
    func cartButton(
        buttonAction: @escaping () -> Void,
        itemsInCart: Int
    ) -> some View {
        
        ZStack {
            Button(action: {
                withAnimation {
                    buttonAction()
                }
            }, label: {
                Image(systemName: "cart")
                    .padding()
                    .bold()
                    .foregroundColor(Color("Secondary"))
            }
            )
            
            if itemsInCart > 0 {
                ZStack {
                    Circle()
                        .foregroundColor(Color("Primary"))
                        .scaledToFill()
                        .frame(width: 10, height: 10, alignment: .topTrailing)
                        .offset(x: 8, y: -10)
                    Text("\(itemsInCart)")
                        .foregroundColor(Color("Secondary"))
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .bold()
                        .frame(width: 10, height: 10, alignment: .topTrailing)
                        .offset(x: 5, y: -10)
                }
            }
        }
    }
}

