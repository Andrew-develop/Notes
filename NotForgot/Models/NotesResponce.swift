//
//  NotesResponce.swift
//  NotForgot
//
//  Created by Sergio Ramos on 12.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation

class NotesResponce: Decodable {
    var id : Int16? = nil
    var title : String? = nil
    var description : String? = nil
    var done : Int16? = nil
    var deadline : Date? = nil
    var category : CategoriesResponce? = nil
    var priority : PrioritiesResponce? = nil
    var created : Date? = nil
}
