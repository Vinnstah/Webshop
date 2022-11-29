import Foundation
import ComposableArchitecture
import SwiftUI
import StyleGuide

public extension UserLocalSettings {
    struct View: SwiftUI.View {
        public let store: StoreOf<UserLocalSettings>
        
        public init(store: StoreOf<UserLocalSettings>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ForceFullScreen {
                    VStack {
                        Text("TBD -- IMPLEMENT COLOR THEME?")
                        
                        VStack {
                            Button("Next step") {
                                viewStore.send(.delegate(.nextStepTapped(
                                    delegating: viewStore.state.user)),
                                               animation: .default)
                            }
                            .buttonStyle(.primary(cornerRadius: 25))
                            
                            Button("Go Back") {
                                viewStore.send(.delegate(.previousStepTapped(delegating: viewStore.state.user)),
                                               animation: .default)}
                                .foregroundColor(Color("Secondary"))
                                .bold()
                                .padding()
                        }
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    viewStore.send(.delegate(.goBackToSignInViewTapped), animation: .default)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
