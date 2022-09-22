//
//  WebshopApp.swift
//  Webshop
//
//  Created by Viktor Jansson on 2022-09-22.
//

import SwiftUI
import AppFeature

@main
struct WebshopApp: App {
    var body: some Scene {
        WindowGroup {
            TestView()
#if os(macOS)
                .frame(minWidth: 1024, maxWidth: .infinity, minHeight: 512, maxHeight: .infinity)
#endif
        }
    }
}
