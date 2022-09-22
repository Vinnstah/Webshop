//
//  File.swift
//  
//
//  Created by Viktor Jansson on 2022-09-22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct App: ReducerProtocol {
    public init() {}
}

public extension App {
    struct State {
        public init(){}
    }
    enum Action {}
    
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
        
    }
}

public extension App {
    struct View: SwiftUI.View {
        let store: StoreOf<App>
        
        public init(store: StoreOf<App>) {
            self.store = store
        }
        
        public var body: some SwiftUI.View {
            Text("TEST")
        }
        
    }
}
