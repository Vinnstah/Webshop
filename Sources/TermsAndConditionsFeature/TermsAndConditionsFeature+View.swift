import Foundation
import ComposableArchitecture
import SwiftUI
import StyleGuide

public extension TermsAndConditions {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<TermsAndConditions>
        
        public init(store: StoreOf<TermsAndConditions>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ForceFullScreen {
                    VStack {
                        ScrollView(.vertical) {
                            Text("""
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                        """)
                        }
                        .frame(width: 300, height: 200)
                        
                        Spacer()
                        
                        HStack {
                            Text("Accept Terms and Conditions")
                            
                            /// This variable should be in a ViewState instead?
                            Image(systemName: viewStore.state.areTermsAndConditionsAccepted ? "checkmark.square" : "square")
                                .onTapGesture {
                                    viewStore.send(.internal(.termsAndConditionsBoxPressed))
                                }
                        }
                        
                        Button("Finish Sign Up") {
                            viewStore.send(.internal(.finishSignUpButtonPressed))
                        }
                        .buttonStyle(.primary(isDisabled: !viewStore.areTermsAndConditionsAccepted, cornerRadius: 25))
                        .disabled(!viewStore.areTermsAndConditionsAccepted)
                        
                        Button("Previous Step") { viewStore.send(.delegate(.previousStep(viewStore.state.user))) }
                            .foregroundColor(Color("Secondary"))
                            .bold()
                            .padding()
                        
                    }
                    .toolbar {
                        ToolbarItem(placement: .destructiveAction) {
                            Button("Cancel") {
                                viewStore.send(.internal(.cancelButtonPressed))
                            }
                        }
                    }
                }
            }
        }
    }
}
