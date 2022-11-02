
import Foundation
import SwiftUI
import ProductViews

public struct NavigationBar<Content: View>: SwiftUI.View  {
    let isRoot: Bool
    let isCartPopulated: () -> Bool
    let isFavourite: Bool?
    let toggleFavourite: () -> Void
    let toggleSettings: () -> Void
    let searchableBinding: Binding<String>
    let content: Content
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    public init(
        isRoot: Bool,
        isCartPopulated: @escaping () -> Bool,
        isFavourite: Bool?,
        toggleFavourite: @escaping () -> Void = {},
        toggleSettings: @escaping () -> Void = {},
        searchableBinding: Binding<String> = .constant(.init()),
        content: () -> Content
    ) {
        self.isRoot = isRoot
        self.isCartPopulated = isCartPopulated
        self.isFavourite = isFavourite
        self.toggleFavourite = toggleFavourite
        self.toggleSettings = toggleSettings
        self.searchableBinding = searchableBinding
        self.content = content()
    }
    
    public var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        HStack {
                            if isRoot {
                                Button(action: { toggleSettings() }, label: {
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
                                        self.mode.wrappedValue.dismiss()
                                    })
                                    .opacity(isRoot ? 0 : 1)
                            }
                            Spacer()
                            if isRoot {
                                searchBar(bindingText: searchableBinding)
                            }
                            
                            favoriteButton(action: { toggleFavourite() }, isFavorite: isFavourite)
                            
                            ZStack {
                                Image(systemName: "cart")
                                    .padding()
                                    .bold()
                                    .foregroundColor(Color("Secondary"))
                                
                                if isCartPopulated() {
                                    Circle()
                                        .foregroundColor(Color("ButtonColor"))
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
public func searchBar(bindingText: Binding<String>) -> some View {
    
    ZStack {
        TextField("", text: bindingText)
            .labelsHidden()
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
        }
    }
}
