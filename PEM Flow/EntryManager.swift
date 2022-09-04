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
    @Published var physicalActivity : Float = 3
    @Published var socialActivity : Float = 3
    @Published var mentalActivity : Float = 3
    @Published var emotionalActivity : Float = 3
    
    @Published var fatigue: Float = 3
    @Published var globalPain: Float = 3
    @Published var gutPain: Float = 3
    @Published var neurologicalPain: Float = 3
    @Published var goodSleep: Bool = false
    
    @Published var crash: Bool = false
    
    @Published var notes: String = ""
    
    private var moc: NSManagedObjectContext
    
    init(context: NSManagedObjectContext){
        moc = context
    }
    
    func saveEntry() {
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
