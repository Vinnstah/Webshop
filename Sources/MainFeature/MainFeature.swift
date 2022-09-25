//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

public struct Main: ReducerProtocol {
    public init() {}
}

public extension Main {
    struct State: Equatable {
        public var defaultCurreny: String
        
        public init(defaultCurrency: String) {
            self.defaultCurreny = defaultCurrency
        }
    }
    
    enum Action: Equatable, Sendable {
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
        
    }
}


public extension Main {
    struct View: SwiftUI.View {
        
        public let store: StoreOf<Main>
        
        public init(store: StoreOf<Main>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            Text("Main Feature goes here")
        }
    }
}
