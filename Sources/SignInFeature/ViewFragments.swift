import Foundation
import SwiftUI

extension SignIn.View {
    @ViewBuilder
    func signInPersonImage() -> some View {
        Image(systemName: "person.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200, alignment: .center)
            .foregroundColor(Color("ButtonColor"))
    }
}
