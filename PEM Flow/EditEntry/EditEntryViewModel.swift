//
//  EditEntryViewModel.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 10/01/2023.
//

import Foundation
import Combine
import CoreData

@MainActor
class EditEntryViewModel: ObservableObject {
    @Published private var dataManager: CoreDataManager
    
    @Published var createdAt: Date = Date()
    
    @Published var physicalActivity : Float = 5
    @Published var socialActivity : Float = 5
    @Published var mentalActivity : Float = 5
    @Published var emotionalActivity : Float = 5
    
    @Published var fatigue: Float = 5
    @Published var globalPain: Float = 5
    @Published var gutPain: Float = 5
    @Published var neurologicalPain: Float = 5
    @Published var goodSleep: Bool = false
    
    @Published var crash: Bool = false
    
    @Published var notes: String = ""
    
    var currentlyEditingEntry: Entry?
    
    var anyCancellable: AnyCancellable? = nil
    
    init(dataManager: CoreDataManager = CoreDataManager.shared) {

        self.dataManager = dataManager
        anyCancellable = dataManager.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        })
        
        //Fetch item according to the date
        
        if let entryAlreadyExists = self.dataManager.fetchFirstByDate(createdAt: createdAt) {
            currentlyEditingEntry = entryAlreadyExists
            self.crash = entryAlreadyExists.crash
            self.goodSleep = entryAlreadyExists.goodSleep
            
            self.gutPain = Float(entryAlreadyExists.gutPain)
            self.globalPain = Float(entryAlreadyExists.globalPain)
            self.neurologicalPain = Float(entryAlreadyExists.neurologicalPain)
            self.fatigue = Float(entryAlreadyExists.fatigue)
            
            self.socialActivity = Float(entryAlreadyExists.socialActivity)
            self.physicalActivity = Float(entryAlreadyExists.physicalActivity)
            self.mentalActivity = Float(entryAlreadyExists.mentalActivity)
            self.emotionalActivity = Float(entryAlreadyExists.emotionalActivity)
            
            self.notes = entryAlreadyExists.notes ?? ""
            
            self.createdAt = entryAlreadyExists.createdAt
            print(entryAlreadyExists.objectID)
        }
    }
    
    func saveEntry() {
        var entry =  Entry(context: dataManager.managedObjectContext)
        entry.id = UUID()
        if let currentEntry = currentlyEditingEntry {
            entry = currentEntry
        }
    
        //Activity
        entry.emotionalActivity = Int16(self.emotionalActivity)
        entry.mentalActivity = Int16(self.mentalActivity)
        entry.socialActivity = Int16(self.socialActivity)
        entry.physicalActivity = Int16(self.physicalActivity)
        
        //Pain
        entry.globalPain = Int16(self.globalPain)
        entry.gutPain = Int16(self.gutPain)
        entry.neurologicalPain = Int16(self.neurologicalPain)
        
        entry.fatigue = Int16(self.fatigue)
        entry.crash = self.crash
        
        entry.notes = self.notes
        
        print(entry.objectID)
        dataManager.saveData()
    }
}
