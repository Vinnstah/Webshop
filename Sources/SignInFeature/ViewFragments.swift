import Foundation
import SwiftUI

extension SignIn.View {
    @ViewBuilder
    func signInPersonImage() -> some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .foregroundColor(Color("ButtonColor"))
            
            Text("Login")
                .font(.system(size: 32))
                .foregroundColor(Color("Secondary"))
        }
    }
}