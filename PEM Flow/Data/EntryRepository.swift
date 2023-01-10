//
//  EntryRepository.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 10/01/2023.
//

import Foundation
import CoreData

extension CoreDataManager {
    func fetchFirstByDate(createdAt date: Date) -> Entry? {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.system
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        
        guard let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) else { return nil }
        
        print(dateFrom)
        print(dateTo)
        let predicate = NSPredicate(format:"(createdAt >= %@) AND (createdAt < %@)", dateFrom as NSDate, dateTo as NSDate)
        
        let result = fetchFirst(Entry.self, predicate: predicate)
        
        switch result {
        case .success(let entry):
            if let fetchedEntry = entry {
                return fetchedEntry
            }
            return nil
        case .failure(let error):
            print("Error whil fetching this entity \(error.localizedDescription)")
            return nil
        }
    }
}
