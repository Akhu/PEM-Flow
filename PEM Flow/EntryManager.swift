//
//  EntryManager.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 01/09/2022.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class EntryManager: ObservableObject {
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
    
    private var cancellables = Set<AnyCancellable>()
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)],
//        animation: .default)
//    var fetchRequest: FetchRequest<Entry>
//    var items: FetchedResults<Entry>
//    private var mocDidSaved = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    @Published var seriesArray = [Series]()
    
    static func importDataFromCSV(input: [RawTrackingData], context: NSManagedObjectContext){
        input.forEach { data in
            let newItem = Entry(context: context)
            newItem.id = UUID()
            newItem.createdAt = data.createdAt
            
            newItem.fatigue = data.fatigue
            newItem.neurologicalPain = data.neurologicalPain
            newItem.gutPain = data.gutPain
            newItem.globalPain = data.globalPain
            
            newItem.physicalActivity = data.physicalActivity
            newItem.mentalActivity = data.mentalActivity
            newItem.socialActivity = data.socialActivity ?? 0
            newItem.emotionalActivity = data.emotionalActivity
            
            newItem.crash = data.crash
            newItem.goodSleep = data.goodSleep
            newItem.notes = data.notes
        }
        try? context.save()
    }

    
    static func generateSampleItems(number: Int, context: NSManagedObjectContext) {
        for i in 0..<20 {
            let newItem = Entry(context: context)
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
        
        try? context.save()
    }
    
    func saveEntry(moc: NSManagedObjectContext) {
        let entry = Entry(context: moc)
        
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
        
        entry.id = UUID()
        entry.notes = self.notes
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    
}
