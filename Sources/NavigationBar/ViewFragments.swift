import SwiftUI
import Foundation
import StyleGuide

public func backButton(action: @escaping () -> ()) -> some View {
    Button(action: {
        action()
    }, label: {
        Image(systemName: "chevron.left")
            .bold()
            .padding()
            .foregroundColor(Color("Secondary"))
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
//isCartEmpty: @escaping () -> Bool
public func cartButton(buttonAction: @escaping () -> Void, itemsInCart: Int ) -> some View {
    
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
