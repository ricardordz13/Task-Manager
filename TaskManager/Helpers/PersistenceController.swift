//
//  PersistenceController.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 03/04/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "TaskManager")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func createAssignment(startDate: Date, endDate: Date, title: String, isComplete: Bool, category: String?) {
        let context = container.viewContext
        let newAssignment = Assignment(context: context)
        newAssignment.startDate = startDate
        newAssignment.endDate = endDate
        newAssignment.title = title
        newAssignment.isComplete = isComplete
        newAssignment.category = category
        
        do {
            try context.save()
        } catch {
            fatalError("Error saving context: \(error)")
        }
    }

    func fetchAssignments() -> [Assignment] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Assignment> = NSFetchRequest<Assignment>(entityName: "Assignment")

        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("Error fetching assignments: \(error)")
        }
    }
}
