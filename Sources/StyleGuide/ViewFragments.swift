import Foundation
import SwiftUI

public func secondaryActionButton(text: String, action: @escaping () -> ()) -> some View {
    Button(text) {
        action()
    }
        .foregroundColor(Color("Secondary"))
        .bold()
        .padding()
}

public func actionButton(text: String, action: @escaping () -> (), isDisabled: @escaping () -> Bool) -> some View {
    Button(text) {
        action()
    }
    .buttonStyle(.primary(isDisabled: isDisabled()))
    .cornerRadius(25)
}
