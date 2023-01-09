import SwiftUI
import Foundation
import StyleGuide

public struct SearchBar: SwiftUI.View {
    public let bindingText: SwiftUI.Binding<String>
    public let showCancel: () -> Bool
    public let cancelSearch: ()-> Void

    public init(
        bindingText: SwiftUI.Binding<String>,
        showCancel: @escaping () -> Bool,
        cancelSearch: @escaping ()-> Void
    ) {
        self.bindingText = bindingText
        self.showCancel = showCancel
        self.cancelSearch = cancelSearch
    }
    public var body: some SwiftUI.View {
        ZStack {
            TextField("", text: bindingText)
                .labelsHidden()
                .background(.white)
                .cornerRadius(20)
                .textFieldStyle(TappableTextFieldStyle())
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .overlay(
                               RoundedRectangle(cornerRadius: 20)
                                   .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                           )
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .bold()
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .opacity(bindingText.wrappedValue == "" ? 1 : 0)
                
                Text("Search")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .opacity(bindingText.wrappedValue == "" ? 1 : 0)
                
                Spacer()
                
                if showCancel() {
                    Button(action: {
                        cancelSearch()
                    }, label: {
                        Image(systemName: "x.circle")
                            .bold()
                            .foregroundColor(.gray)
                    })
                }
            }
        }
    }
}

public struct CustomTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.largeTitle)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.primary.opacity(0.5), lineWidth: 3))
    }
}
