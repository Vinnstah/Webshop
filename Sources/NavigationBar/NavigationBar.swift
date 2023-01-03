//import Foundation
//import SwiftUI
//import ProductViews
//import StyleGuide
//import ComposableArchitecture
//import Product


import Foundation
import SwiftUI
import ProductViews
import StyleGuide

public struct NavigationBar<Content: View>: SwiftUI.View  {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let isRoot: Bool
//    let isCartPopulated: () -> Bool
    let itemsInCart: Int
    let showCartQuickView: () -> Void
    let isFavourite: () -> Bool?
    let showFavouriteSymbol: () -> Void
    let showSettingsSymbol: () -> Void
    let searchableBinding: Binding<String>
    let cancelSearch: () -> Void
    let previousScreenAction: () -> Void
    let content: Content
    
    public init(
        isRoot: Bool,
//        isCartPopulated: @escaping () -> Bool,
        itemsInCart: Int,
        showCartQuickView: @escaping () -> Void,
        isFavourite: @escaping () -> Bool? = { nil },
        showFavouriteSymbol: @escaping () -> Void = {},
        showSettingsSymbol: @escaping () -> Void = {},
        searchableBinding: Binding<String> = .constant(.init()),
        cancelSearch: @escaping () -> Void,
        previousScreenAction: @escaping () -> Void,
        content: () -> Content
    ) {
        self.isRoot = isRoot
        self.itemsInCart = itemsInCart
//        self.isCartPopulated = isCartPopulated
        self.showCartQuickView = showCartQuickView
        self.isFavourite = isFavourite
        self.showFavouriteSymbol = showFavouriteSymbol
        self.showSettingsSymbol = showSettingsSymbol
        self.searchableBinding = searchableBinding
        self.cancelSearch = cancelSearch
        self.previousScreenAction = previousScreenAction
        self.content = content()
    }
    
    public var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        HStack {
                            if isRoot {
                                settingsButton(action: { showSettingsSymbol() })
                            } else {
                                backButton(action: { previousScreenAction() })
                            }
                            
                            Spacer()
                            
                            if isRoot {
                                SearchBar(
                                    bindingText: searchableBinding,
                                    showCancel: { searchableBinding.wrappedValue != "" },
                                    cancelSearch: { cancelSearch() }
                                )
                            }
                            
                            favoriteButton(
                                action: { showFavouriteSymbol() },
                                isFavorite: isFavourite(),
                                bgColor: Color("Background")
                            )
                            
                            cartButton(buttonAction: { showCartQuickView() }, itemsInCart: itemsInCart )
//                            cartButton(buttonAction: { showCartQuickView() }, isCartEmpty: { isCartPopulated() } )
                            
                            
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
////
////@ViewBuilder
////public func searchBar(bindingText: Binding<String>, showCancel: @escaping () -> Bool, cancelSearch: @escaping ()->Void) -> some View {
////    
////    ZStack {
////        TextField("", text: bindingText)
////            .labelsHidden()
////            .textFieldStyle(TappableTextFieldStyle())
////            .textInputAutocapitalization(.never)
////            .autocorrectionDisabled()
////            .padding(.horizontal)
////            .foregroundColor(Color("Secondary"))
////        
////        HStack {
////            
////            Image(systemName: "magnifyingglass")
////                .bold()
////                .foregroundColor(.gray)
////                .padding(.horizontal)
////                .opacity(bindingText.wrappedValue == "" ? 1 : 0)
////            
////            Text("Search")
////                .font(.footnote)
////                .foregroundColor(.gray)
////                .opacity(bindingText.wrappedValue == "" ? 1 : 0)
////            
////            Spacer()
////            if showCancel() {
////                Button(action: {
////                    cancelSearch()
////                }, label: {
////                    Image(systemName: "x.circle")
////                        .bold()
////                        .foregroundColor(.gray)
////                })
////            }
////        }
////    }
////}
////
////public struct CustomTextFieldStyle : TextFieldStyle {
////    public func _body(configuration: TextField<Self._Label>) -> some View {
////        configuration
////            .font(.largeTitle)
////            .padding(10)
////            .background(
////                RoundedRectangle(cornerRadius: 5)
////                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 3))
////    }
////}
