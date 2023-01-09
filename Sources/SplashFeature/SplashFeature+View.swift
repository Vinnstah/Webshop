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
                    
                    animatedTitle(animate: { viewStore.state.isAnimating } )
                        .onAppear {
                            viewStore.send(.internal(.onAppear))
                        }
                }
            }
        }
    }
    
    
}


