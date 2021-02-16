//
//  Kategory+CoreDataProperties.swift
//  NotForgot
//
//  Created by Sergio Ramos on 11.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var category_id: Int16
    @NSManaged public var name: String?
    @NSManaged public var note: Note?

}

extension Category : Identifiable {

}
