import Foundation
import SwiftUI

extension Splash.View {
    @ViewBuilder
    func animatedLetter(
        letter: String,
        startingPosition: CGSize,
        endPosition: CGSize,
        animate: () -> Bool
    ) -> some View {
        Text(letter)
            .bold()
            .frame(width: 13, height: 13)
            .offset(animate() ? endPosition : startingPosition)
            .animation(.easeIn(duration: 1.7), value: animate())
            .foregroundColor(Color("Secondary"))
        
    }
}

extension Splash.View {
    @ViewBuilder
    func animatedTitle(animate: () -> Bool) -> some View {
        
        animatedLetter(
            letter: "W",
            startingPosition: .init(width: -150, height: -300),
            endPosition: .init(width: -40, height: 0),
            animate: {
                animate()
            }
        )
        animatedLetter(
            letter: "E",
            startingPosition: .init(width: -200, height: -200),
            endPosition: .init(width: -30, height: 0),
            animate: {
                animate()
            }
        )
        animatedLetter(
            letter: "B",
            startingPosition: .init(width: -100, height: -100),
            endPosition: .init(width: -20, height: 0),
            animate: {
                animate()
            }
        )
        animatedLetter(
            letter: "S",
            startingPosition: .init(width: 100, height: -200),
            endPosition: .init(width: -10, height: 0),
            animate: {
                animate()
            }
        )
        animatedLetter(
            letter: "H",
            startingPosition: .init(width: 250, height: -300),
            endPosition: .init(width: 0, height: 0),
            animate: {
                animate()
            }
        )
        animatedLetter(
            letter: "O",
            startingPosition: .init(width: 350, height: -400),
            endPosition: .init(width: 10, height: 0),
            animate: {
                animate()
            }
        )
        animatedLetter(
            letter: "P",
            startingPosition: .init(width: -150, height: -300),
            endPosition: .init(width: 20, height: 0),
            animate: {
                animate()
            }
        )
    }
}
