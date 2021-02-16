//
//  Priority+CoreDataProperties.swift
//  NotForgot
//
//  Created by Sergio Ramos on 11.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Priority {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Priority> {
        return NSFetchRequest<Priority>(entityName: "Priority")
    }

    @NSManaged public var name: String?
    @NSManaged public var priority_id: Int16
    @NSManaged public var note: Note?

}

extension Priority : Identifiable {

}
