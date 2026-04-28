//
//  ToDo_TaskApp.swift
//  ToDo Task
//
//  Created by fai on 04/17/26.
//

import SwiftUI

@main
struct ToDo_TaskApp: App {
    @StateObject private var localeManager = LocaleManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localeManager)
                .environment(\.layoutDirection, localeManager.currentLanguage.layoutDirection)
                .animation(.easeInOut(duration: 0.3), value: localeManager.currentLanguage)
        }
    }
}
