//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 21/03/24.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
