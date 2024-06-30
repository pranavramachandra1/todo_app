//
//  todo_appApp.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/25/24.
//

import SwiftUI

@main
struct todo_appApp: App {
    @StateObject var listLibrary = ListLibrary()
    @StateObject var listManager: ListManager

    init() {
        // Initialize ListLibrary
        let library = ListLibrary()
        // Initialize ListManager with the library instance
        _listManager = StateObject(wrappedValue: ListManager(listLibrary: library))
        // Assign the initialized library to @StateObject
        _listLibrary = StateObject(wrappedValue: library)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listManager)
                .environmentObject(listLibrary)
                .onAppear {
                    print(URL.documentsDirectory.path)
                }
        }
    }
}
