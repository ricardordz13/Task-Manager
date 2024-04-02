//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 21/03/24.
//

import SwiftUI

@main
struct TaskManagerApp: App {

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "clock")
                        Text("Tasks")
                    }
            }
            .accentColor(.teal)
        }
        .modelContainer(for: Assignment.self)
    }
}
