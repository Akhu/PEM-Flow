//
//  CoreDataManager.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 09/01/2023.
//

import Foundation
import CoreData
import OrderedCollections

enum CoreDataManagerType {
    case normal, preview, testing
}

enum DataState {
    case unfetched, loading, fetched, noData
    case error(Error)
}

class CoreDataManager: NSObject, ObservableObject {
    
    public static var shared = CoreDataManager(type: .normal)
    public static var preview = CoreDataManager(type: .preview)
    public static var testing = CoreDataManager(type: .testing)

    var managedObjectContext: NSManagedObjectContext
    
    private let entriesFetchResultsController: NSFetchedResultsController<Entry>
    
    var entries : [Entry] {
        Array(self.entriesOrdered.values)
    }
    @Published var entriesOrdered: OrderedDictionary<Date, Entry> = [:]
    
    private init(type: CoreDataManagerType) {
        //Todo from CoreDataExemple Project
        switch type {
        case .normal:
            let persistentStore = PersistentStore()
            self.managedObjectContext = persistentStore.context
        case .preview:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
            EntryManager.generateSampleItems(number: 10, context: managedObjectContext)
            try? self.managedObjectContext.save()
        case .testing:
            let persistentStore = PersistentStore(inMemory: true)
            self.managedObjectContext = persistentStore.context
        }
        
        //Useless
        let entriesFR: NSFetchRequest<Entry> = Entry.fetchRequest()
        entriesFR.sortDescriptors = [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)]
        entriesFetchResultsController = NSFetchedResultsController(fetchRequest: entriesFR, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        entriesFetchResultsController.delegate = self
    }
    
    func deleteEntry(_ entry: Entry){
        managedObjectContext.delete(entry)
        self.saveData()
    }
    
    func generateSamples(_ number: Int = 10){
        for i in 0..<20 {
            let newItem = Entry(context: managedObjectContext)
            newItem.id = UUID()
            newItem.createdAt = Date().addingTimeInterval(-(86400*Double(i)))
            newItem.fatigue = Int16.random(in: 0...10)
            newItem.physicalActivity = Int16.random(in: 0...10)
            newItem.socialActivity = Int16.random(in: 0...10)
            newItem.mentalActivity = Int16.random(in: 0...5)
            newItem.emotionalActivity = Int16.random(in: 0...10)
            
            newItem.gutPain = Int16.random(in: 0...10)
            newItem.globalPain = Int16.random(in: 0...10)
            newItem.neurologicalPain = Int16.random(in: 0...10)
            newItem.crash = Bool.random()
            newItem.goodSleep = Bool.random()
        }
        self.saveData()
    }
    
    func deleteAllEntries(){
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try self.managedObjectContext.execute(deleteRequest)
            try self.managedObjectContext.save()
            self.fetchEntries()
        } catch {
            print ("There was an error")
        }
        
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context : \(error), \(error.userInfo)")
            }
        }
    }
    
    
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newEntries = controller.fetchedObjects as? [Entry] {
            self.entriesOrdered = OrderedDictionary(uniqueKeysWithValues: newEntries.map({ ($0.createdAt, $0 ) }))
        }
    }

    func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchEntries(withPredicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        
        if let predicate = withPredicate {
            entriesFetchResultsController.fetchRequest.predicate = predicate
        }
        
        if let sortDescriptors = sortDescriptors {
            entriesFetchResultsController.fetchRequest.sortDescriptors = sortDescriptors
        }
        
        try? entriesFetchResultsController.performFetch()
        if let newEntries = entriesFetchResultsController.fetchedObjects {
            self.entriesOrdered = OrderedDictionary(uniqueKeysWithValues: newEntries.map({ ($0.createdAt, $0) }))
        }
    }
}
