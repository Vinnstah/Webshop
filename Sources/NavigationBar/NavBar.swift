import Foundation
import SwiftUI
import ProductViews
import StyleGuide
import ComposableArchitecture
import Product
import HomeFeature
import FavoriteFeature

public struct NavBar<Content: View>: SwiftUI.View {
    
    let store: StoreOf<Home>
    let content: Content
    
    public init(
        store: StoreOf<Home>, content: () -> Content
    ) {
        self.store = store
        self.content = content()
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 } ) { viewStore in
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        ZStack {
                            HStack {
                                if !viewStore.state.showDetailView {
                                    Button(action: { viewStore.send(.internal(.settingsButtonTapped)) }, label: {
                                        Image(systemName: "gearshape")
                                            .bold()
                                            .padding()
                                            .foregroundColor(Color("Secondary"))
                                    })
                                } else {
                                    
                                    backButton(
                                        action: { viewStore.send(.detailView(.toggleDetailView(nil)), animation: .easeOut) },
                                        detailViewShown: { viewStore.state.showDetailView })
                                }
                                
                                Spacer()
                                
                                if !viewStore.state.showDetailView {
                                    searchBar(
                                        bindingText: viewStore.binding(
                                            get: { $0.searchText },
                                            send: { .internal(.searchTextReceivingInput(text: $0)) }).animation(),
                                        showCancel: { viewStore.state.searchText != "" },
                                        cancelSearch: { viewStore.send(.internal(.cancelSearchTapped), animation: .default) }
                                    )
                                }
                                if viewStore.state.showDetailView {
                                    favoriteButton(
                                        action: { viewStore.send(.favorite(.addFavouriteProduct(viewStore.state.product!.id))) },
                                        isFavorite:
                                            viewStore.state.favoriteProducts.sku.contains { $0 == viewStore.state.product!.id },
                                        bgColor: Color("BackgroundColor")
                                    )
                                }
                                
                                ZStack{
                                    Button(action: {
                                        //CART
                                    }, label: {
                                        Image(systemName: "cart")
                                            .padding()
                                            .bold()
                                            .foregroundColor(Color("Secondary"))
                                    })
                                    
                                    if viewStore.state.cart != nil {
                                        Circle()
                                            .foregroundColor(Color("Primary"))
                                            .scaledToFill()
                                            .frame(width: 10, height: 10, alignment: .topTrailing)
                                            .offset(x: 8, y: -10)
                                    }
                                }
                                
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
