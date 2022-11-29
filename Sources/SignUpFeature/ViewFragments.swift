import Foundation
import SwiftUI

extension SignUp.View {
    func signUpImage() -> some View {
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

extension SignUp.View {
    public func credentialCheckerIndicator(action: @escaping () -> Bool) -> some View {
        return Image(systemName: action() ? "checkmark" : "xmark")
            .foregroundColor(action() ? .green : .red)
    }
}
