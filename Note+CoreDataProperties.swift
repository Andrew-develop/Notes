//
//  Note+CoreDataProperties.swift
//  NotForgot
//
//  Created by Sergio Ramos on 11.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var note_id: Int16
    @NSManaged public var deadline: Date?
    @NSManaged public var name: String?
    @NSManaged public var status: Bool
    @NSManaged public var zamDescription: String?
    @NSManaged public var category: Category?
    @NSManaged public var priority: Priority?

}

extension Note : Identifiable {

}
