import Foundation
import ComposableArchitecture
import SwiftUI
import StyleGuide

public extension UserLocalSettings {
    struct View: SwiftUI.View {
        public let store: StoreOf<UserLocalSettings>
        let columns = [
            GridItem(.fixed(100)),
            GridItem(.flexible()),
        ]
        
        public init(store: StoreOf<UserLocalSettings>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ForceFullScreen {
                    VStack {
                        Text("TBD -- IMPLEMENT COLOR THEME?")
                        Text("Choose your favourite category")
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns, content: {
                                ForEach(viewStore.state.categories) { cat in
                                    CardView(category: cat)
                                }
                            }
                            )
                        }
                        
                        actionButton(
                            text: "Next Step",
                            action: { viewStore.send(.delegate(.nextStepTapped(
                                delegating: viewStore.state.user)),
                                                     animation: .default)},
                            isDisabled: { false })
                        
                        secondaryActionButton(
                            text: "Go Back",
                            action: {viewStore.send(.delegate(.previousStepTapped(
                                delegating: viewStore.state.user)),
                                                    animation: .default)})
                    }
                }
            }
        }
    }
}

//}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        UserLocalSettings.View(store: Store(initialState: UserLocalSettings.State(user: .init(credentials: .init(email: "Tester", password: "test"))), reducer: UserLocalSettings()))
    }
}
