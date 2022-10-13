
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
                    ScrollView(.horizontal) {
                        ForEach(viewStore.state.productList, id: \.self) { prod in
                            ProductView(store: store, title: prod)
                        }
                    }
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

public struct ProductView: SwiftUI.View {
    public let store: StoreOf<Main>
    let title: String
    
    public init(store: StoreOf<Main>, title: String) {
        self.store = store
        self.title = title
    }
    
    public var body: some SwiftUI.View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Text(title)
                Rectangle()
                    .frame(width: 200, height: 250)
                    .background(Color(.blue))
            }
        }
    }
    
    
}
