//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-10-07.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import UserModel

public extension UserInformation {
    struct View: SwiftUI.View {
        public let store: StoreOf<UserInformation>
        
        public init(store: StoreOf<UserInformation>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                VStack {
                    Text("View to fill in all information")
                    
                    Picker("Default Currency", selection: viewStore.binding(
                        get: { $0.userSettings?.defaultCurrency ?? .SEK },
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

