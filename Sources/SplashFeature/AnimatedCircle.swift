import Foundation
import SwiftUI

extension Splash.View {
    @ViewBuilder
    func animatedCircle(
        startingPosition: CGSize,
        endPosition: CGSize,
        animate: () -> Bool
    ) -> some View {
        Circle()
            .stroke()
            .bold()
            .frame(width: 13, height: 13)
            .offset(animate() ? endPosition : startingPosition)
            .animation(.easeIn(duration: 1.7), value: animate())
            .foregroundColor(Color("Secondary"))
        
    }
}
