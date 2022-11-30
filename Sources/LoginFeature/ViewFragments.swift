import Foundation
import SwiftUI

extension Login.View {
    func loginImage() -> some View {
        VStack {
            ZStack {
                Circle()
                    .scaledToFit()
                    .frame(width: 450, height: 450)
                    .foregroundColor(Color("Primary"))
                    .offset(x: -150, y: -150)
                
                Circle()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .foregroundColor(Color("Secondary"))
                    .offset(x: 50, y: 0)
            }
            .frame(width: 200)
            
            Text("Login")
                .font(.system(size: 32))
                .foregroundColor(Color("Secondary"))
        }
    }
}
