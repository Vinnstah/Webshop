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
                        Text("User Settings")
                        Text("Currency disabled")
//                        Picker("Default Currency", selection: viewStore.binding(
//                            get: { $0.userSettings.defaultCurrency },
//                            send: { .internal(.defaultCurrencyChosen($0)) }
//                        )
//                        ) {
//                            ForEach(Currency.allCases, id: \.self) {
//                                Text($0.rawValue)
//                            }
//                        }
//                        .pickerStyle(.inline)
//                        .padding()
                        
                        VStack {
                            Button("Next step") {
                                viewStore.send(.internal(.nextStep), animation: .default)
                            }
                            .buttonStyle(.primary(cornerRadius: 25))
                            
                            Button("Go Back") { viewStore.send(.internal(.previousStep), animation: .default)}
                                .foregroundColor(Color("Secondary"))
                                .bold()
                                .padding()
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
    }
    
}
