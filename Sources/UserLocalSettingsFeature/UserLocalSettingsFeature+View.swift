import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel

public extension UserLocalSettings {
    struct View: SwiftUI.View {
        public let store: StoreOf<UserLocalSettings>
        
        public init(store: StoreOf<UserLocalSettings>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("View to fill in all information")
                    
                    Picker("Default Currency", selection: viewStore.binding(
                        get: { $0.userSettings.defaultCurrency },
                        send: { .internal(.defaultCurrencyChosen($0)) }
                    )
                    ) {
                        ForEach(Currency.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .padding()
                    
                    Button("Next step") {
                        viewStore.send(.internal(.nextStep))
                    }
                        Button("Previous Step") { viewStore.send(.internal(.previousStep))}
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            viewStore.send(.internal(.cancelButtonPressed))
                        }
                    }
                }
            }
        }
    }
}

