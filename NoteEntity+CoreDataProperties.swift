//
//  NoteEntity+CoreDataProperties.swift
//  
//
//  Created by dewill on 10/08/2019.
//
//

import Foundation
import CoreData


extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        return NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    @NSManaged public var color: String?
    @NSManaged public var content: String?
    @NSManaged public var importance: Int16
    @NSManaged public var selfDestructionDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var uid: String?

}
