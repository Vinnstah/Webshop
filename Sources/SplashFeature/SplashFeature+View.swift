import Foundation
import SwiftUI
import ComposableArchitecture
import StyleGuide

public extension Splash {
    struct View: SwiftUI.View {
        public let store: StoreOf<Splash>
        
        public init(store: StoreOf<Splash>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ForceFullScreen {
                ZStack {
                    Text("  Websh    p")
                        .foregroundColor(Color("Secondary"))
                        .font(.headline)
                        .bold()
                        
                    
                    animatedCircle(
                        startingPosition: .init(width: 25, height: -500),
                        endPosition: .init(width: 25, height: 0),
                        animate: {
                            viewStore.state.isAnimating
                        }
                    )
                }
                .onAppear {
                    viewStore.send(.internal(.onAppear))
                }
            }
            }
        }
    }
    
    
}


