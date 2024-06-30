//
//  todo_appApp.swift
//  todo_app
//
//  Created by Pranav Ramachandra on 6/25/24.
//

import SwiftUI

@main
struct todo_appApp: App {
    @StateObject var listManager = ListManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listManager)
                .onAppear {
                    print(URL.documentsDirectory.path)
                }
        }
    }
}
