//
//  NoteApp_MultiPlatformApp.swift
//  Shared
//
//  Created by GOURAVM on 24/08/22.
//

import SwiftUI

@main
struct NoteApp_MultiPlatformApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}
