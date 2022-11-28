import Foundation
import SwiftUI

extension SignIn.View {
    @ViewBuilder
    func emailTextField(text: Binding<String>) -> some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15, alignment: .center)
                .foregroundColor(Color("Secondary"))
                .padding(.leading, 10)
            
            TextField("Email", text: text
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .foregroundColor(Color("Secondary"))
            .padding(5)
            .border(.opacity(100))
        }
        .background {
            Color.white
        }
        .border(Color("Secondary"))
    }
}
