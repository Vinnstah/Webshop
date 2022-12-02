import SwiftUI
import Foundation
import Boardgame
import IdentifiedCollections

public extension UserLocalSettings.View {
    struct LazyVerticalGrid: View {
        //    @ViewBuilder
        //    func lazyVGrid(categories: IdentifiedArrayOf<Boardgame.Category>, onTapAction: @escaping () -> ()) -> some View {
        let categories: IdentifiedArrayOf<Boardgame.Category>
        let columns: [GridItem] = .init(repeating: .init(.flexible(), spacing: 10), count: 2)
        
        public var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(categories) { category in
                    CardView(category: category)
                }
                
            }
        }
    }
}

public extension UserLocalSettings.View {
    struct CardView: View {
        let category: Boardgame.Category
        
        public var body: some View {
            ZStack {
                Rectangle()
                    .frame(width: 75, height: 100)
                    .border(Color("Secondary"))
                    .cornerRadius(25)
                VStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(Color("Primary"))
                    Text(category.rawValue)
                        .foregroundColor(Color("Primary"))
                }
            }
        }
    }
}
