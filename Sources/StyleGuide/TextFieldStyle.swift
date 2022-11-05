
import Foundation
import SwiftUI

public struct TappableTextFieldStyle: TextFieldStyle {
    @FocusState private var textFieldFocused: Bool
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal)
            .focused($textFieldFocused)
            .onTapGesture {
                textFieldFocused = true
            }
    }
}
