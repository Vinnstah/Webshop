
import Foundation
import SwiftUI
import ProductViews
import StyleGuide

public struct NavigationBar<Content: View>: SwiftUI.View  {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let isRoot: Bool
    let isCartPopulated: () -> Bool
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
        isCartPopulated: @escaping () -> Bool,
        showCartQuickView: @escaping () -> Void,
        isFavourite: @escaping () -> Bool? = {nil},
        showFavouriteSymbol: @escaping () -> Void = {},
        showSettingsSymbol: @escaping () -> Void = {},
        searchableBinding: Binding<String> = .constant(.init()),
        cancelSearch: @escaping () -> Void,
        previousScreenAction: @escaping () -> Void,
        content: () -> Content
    ) {
        self.isRoot = isRoot
        self.isCartPopulated = isCartPopulated
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
                                Button(action: { showSettingsSymbol() }, label: {
                                    Image(systemName: "gearshape")
                                        .bold()
                                        .padding()
                                        .foregroundColor(Color("Secondary"))
                                })
                            } else {
                                Image(systemName: "chevron.left")
                                    .bold()
                                    .padding()
                                    .foregroundColor(Color("Secondary"))
                                    .onTapGesture(count: 1, perform: {
                                        previousScreenAction()
                                    })
                                    .opacity(isRoot ? 0 : 1)
                            }
                            Spacer()
                            if isRoot {
                                searchBar(
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
                            
                            ZStack {
                                Button(action: {
                                    showCartQuickView()
                                }, label: {
                                    Image(systemName: "cart")
                                        .padding()
                                        .bold()
                                        .foregroundColor(Color("Secondary"))
                                })
                                
                                if isCartPopulated() {
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

@ViewBuilder
public func searchBar(bindingText: Binding<String>, showCancel: @escaping () -> Bool, cancelSearch: @escaping ()->Void) -> some View {
    
    ZStack {
        TextField("", text: bindingText)
            .labelsHidden()
            .textFieldStyle(TappableTextFieldStyle())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal)
            .foregroundColor(Color("Secondary"))
        
        HStack {
            
            Image(systemName: "magnifyingglass")
                .bold()
                .foregroundColor(.gray)
                .padding(.horizontal)
                .opacity(bindingText.wrappedValue == "" ? 1 : 0)
            
            Text("Search")
                .font(.footnote)
                .foregroundColor(.gray)
                .opacity(bindingText.wrappedValue == "" ? 1 : 0)
            
            Spacer()
            if showCancel() {
                Button(action: {
                    cancelSearch()
                }, label: {
                    Image(systemName: "x.circle")
                        .bold()
                        .foregroundColor(.gray)
                })
            }
        }
    }
}

public struct CustomTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.largeTitle)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 3))
    }
}
