
import Foundation
import SwiftUI
import ComposableArchitecture

public extension Main {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Main>
        
        public init(store: StoreOf<Main>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("Main Feature goes here")
                    

                    
                    HStack {
                        Text("JWT TOKEN: ")
                        Text(viewStore.state.jwt)
                    }
                    
                    Button("Log out user") {
                        viewStore.send(.internal(.logOutUser))
                    }
                }
            }
        }
    }
}

