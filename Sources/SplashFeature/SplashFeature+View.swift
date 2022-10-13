import Foundation
import SwiftUI
import ComposableArchitecture

public extension Splash {
    struct View: SwiftUI.View {
        public let store: StoreOf<Splash>
        
        public init(store: StoreOf<Splash>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                Text("SPLASH SCREEN")
                    .onAppear {
                        viewStore.send(.internal(.onAppear))
                    }
                    .background(Color(red: 52, green: 73, blue: 102))
                    .frame(width: 600, height: 400)
               
                
            }
            .background(Color(red: 13, green: 24, blue: 33))
        }
    }
}

