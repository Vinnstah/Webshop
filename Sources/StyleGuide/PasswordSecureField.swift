import Foundation
import SwiftUI

@ViewBuilder
public func passwordTextField(text: Binding<String>) -> some View {
    HStack {
        Image(systemName: "lock.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 15, height: 15, alignment: .center)
            .foregroundColor(Color("Secondary"))
            .padding(.leading, 10)
        
        SecureField("Password", text: text
        )
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .foregroundColor(Color("Secondary"))
        .padding(5)
        .border(.opacity(100))
        
        
    }
    .background {
        Color.white
    }
    .border(Color("Secondary"))
}

