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

public func settingsButton(action: @escaping () -> Void) -> some View {
    
    Button(action: { action() }, label: {
        Image(systemName: "gearshape")
            .bold()
            .padding()
            .foregroundColor(Color("Secondary"))
    })
}

public func cartButton(buttonAction: @escaping () -> Void, isCartEmpty: @escaping () -> Bool) -> some View {
    
    ZStack {
        Button(action: {
            buttonAction()
        }, label: {
            Image(systemName: "cart")
                .padding()
                .bold()
                .foregroundColor(Color("Secondary"))
        }
        )
        
        if !isCartEmpty() {
            Circle()
                .foregroundColor(Color("Primary"))
                .scaledToFill()
                .frame(width: 10, height: 10, alignment: .topTrailing)
                .offset(x: 8, y: -10)
        }
    }
}
