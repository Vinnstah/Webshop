import SwiftUI
import Foundation
import StyleGuide

@ViewBuilder
public func searchBar(bindingText: Binding<String>, showCancel: @escaping () -> Bool, cancelSearch: @escaping ()->Void) -> some View {
    
    ZStack {
        TextField("", text: bindingText)
            .labelsHidden()
            .textFieldStyle(TappableTextFieldStyle())
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal)
            .foregroundColor(Color("Secondary"))
        
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
