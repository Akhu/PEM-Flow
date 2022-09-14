//
//  Entry+CoreDataProperties.swift
//  PEM Flow
//
//  Created by Anthony Da cruz on 01/09/2022.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }
    @NSManaged public var createdAt: Date
    @NSManaged public var physicalActivity: Int16
    @NSManaged public var socialActivity: Int16
    @NSManaged public var mentalActivity: Int16
    @NSManaged public var emotionalActivity: Int16
    @NSManaged public var fatigue: Int16
    @NSManaged public var goodSleep: Bool
    @NSManaged public var globalPain: Int16
    @NSManaged public var gutPain: Int16
    @NSManaged public var neurologicalPain: Int16
    @NSManaged public var crash: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?

    var unwrappedId: UUID {
        id ?? UUID()
    }
    
    var unwrappedNotes: String {
        notes ?? ""
    }
    
    public override func awakeFromInsert() {
        setPrimitiveValue(NSDate(), forKey: "createdAt")
    }
}

extension Entry : Identifiable {

}
