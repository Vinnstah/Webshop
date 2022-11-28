import Foundation
import SwiftUI

extension SignUp.View {
    @ViewBuilder
    func signUpPersonImage() -> some View {
        VStack {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .foregroundColor(Color("ButtonColor"))
            
            Text("Create User")
                .font(.system(size: 32))
        }
    }
}
