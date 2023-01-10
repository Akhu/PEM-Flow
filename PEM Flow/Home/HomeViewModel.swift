//
//  HomeViewModel.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 10/01/2023.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    
    @Published private var dataManager: CoreDataManager
    
    var anyCancellable: AnyCancellable? = nil
    var viewCancellables = Set<AnyCancellable>()
    
    @Published var historySize: HistorySize = .sinceTwoWeeks
    @Published var displayCrash = false
    
    @Published var dataState:DataState = .unfetched
    
    init(dataManager: CoreDataManager = CoreDataManager.shared){
        self.dataManager = dataManager

        anyCancellable = dataManager.objectWillChange.sink(receiveValue: { [weak self] (_) in
            self?.objectWillChange.send()
        })
        
        $historySize
            .receive(on: DispatchQueue.main)
            .sink { newValue in
                self.fetchEntries()
            }
            .store(in: &viewCancellables)
    }
    
    var entries: [Entry] {
        dataManager.entries
    }
    
    func addSampleEntries() {
        self.dataManager.generateSamples(10)
    }
    
    func deleteEntry(_ entry: Entry) {
        self.dataState = .loading
        self.dataManager.deleteEntry(entry)
        self.dataState = .fetched
    }
    
    func deleteAllEntries() {
        self.dataState = .loading
        self.dataManager.deleteAllEntries()
        self.dataState = .fetched
    }
    
    func getHistorySizeAsStartInterval() -> Date? {
        let calendar = Calendar.current
        switch historySize {
            case .sinceTwoWeeks:
                return calendar.date(byAdding: .day, value: -14, to: Date())!
            case .sinceAMonth:
               return calendar.date(byAdding: .month, value: -1, to: Date())!
            case .all:
             return  nil
            
        }
    }

    func fetchEntries() {
        self.dataState = .loading
        var predicate: NSPredicate? = nil
        if let historySizeHasDate = getHistorySizeAsStartInterval() {
            predicate = NSPredicate(format:"(createdAt >= %@) AND (createdAt < %@)", historySizeHasDate as NSDate, Date() as NSDate)
        }
        let sortDescriptor = [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: true)]
        
        self.dataManager.fetchEntries(withPredicate: predicate, sortDescriptors: sortDescriptor)
        dataState = .fetched
    }
}
