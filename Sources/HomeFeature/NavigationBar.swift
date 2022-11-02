
import Foundation
import SwiftUI
import ProductViews

public struct NavigationBar<Content: View>: SwiftUI.View  {
    let isRoot: Bool
    let isCartPopulated: () -> Bool
    let isFavourite: Bool?
    let toggleFavourite: () -> Void 
    let content: Content
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    public init(
        isRoot: Bool,
        isCartPopulated: @escaping () -> Bool,
        isFavourite: Bool?,
        toggleFavourite: @escaping () -> Void = {},
        content: () -> Content
    ) {
        self.isRoot = isRoot
        self.isCartPopulated = isCartPopulated
        self.isFavourite = isFavourite
        self.toggleFavourite = toggleFavourite
        self.content = content()
    }
    
    public var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        HStack {
                            Image(systemName: "chevron.left")
                                .bold()
                                .padding()
                                .foregroundColor(Color("Secondary"))
                                .onTapGesture(count: 1, perform: {
                                    self.mode.wrappedValue.dismiss()
                                })
                                .opacity(isRoot ? 0 : 1)
                            
                            Spacer()
                            
                            favoriteButton(action: toggleFavourite(), isFavorite: isFavourite)
                            
                            ZStack {
                                Image(systemName: "cart")
                                    .padding()
                                    .bold()
                                    .foregroundColor(Color("Secondary"))
                                
                                if isCartPopulated() {
                                    Circle()
                                        .foregroundColor(.red)
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
