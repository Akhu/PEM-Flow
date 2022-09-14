//
//  Persistence.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 26/08/2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Entry(context: viewContext)
            newItem.id = UUID()
            newItem.createdAt = Date().addingTimeInterval(-(86400*Double(i)))
            print(Date().addingTimeInterval(-(86400*Double(i))))
            newItem.fatigue = Int16.random(in: 0...5)
            newItem.physicalActivity = Int16.random(in: 0...5)
            newItem.socialActivity = Int16.random(in: 0...5)
            newItem.mentalActivity = Int16.random(in: 0...5)
            newItem.emotionalActivity = Int16.random(in: 0...5)
            
            newItem.gutPain = Int16.random(in: 0...5)
            newItem.globalPain = Int16.random(in: 0...5)
            newItem.neurologicalPain = Int16.random(in: 0...5)
            newItem.crash = Bool.random()
            newItem.goodSleep = Bool.random()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PEM_Flow")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
