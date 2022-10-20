//
//  WebshopApp.swift
//  Webshop
//
//  Created by Viktor Jansson on 2022-09-22.
//asf

import SwiftUI
import AppFeature
import ComposableArchitecture

@main
struct WebshopApp: SwiftUI.App {
    
    var body: some Scene {
        WindowGroup {
            App.View(store:
                        Store(initialState: .init(), reducer: App()._printChanges())
                             )
            
                
#if os(macOS)
                .frame(minWidth: 1024, maxWidth: .infinity, minHeight: 512, maxHeight: .infinity)
#endif
        }
    }
}

