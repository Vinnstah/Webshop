import SwiftUI
import Foundation

public func backButton(action: @escaping () -> (), detailViewShown: @escaping () -> Bool) -> some View {
    Button(action: {
action()
    }, label: {
        
        Image(systemName: "chevron.left")
            .bold()
            .padding()
            .foregroundColor(Color("Secondary"))
            .opacity(detailViewShown() ? 1 : 0)
    })
}
