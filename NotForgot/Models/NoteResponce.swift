//
//  NoteResponce.swift
//  NotForgot
//
//  Created by Sergio Ramos on 13.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation

class NoteResponce : Decodable {
    var id : Int16? = nil
    var title : String? = nil
    var description : String? = nil
    var done : Int16? = nil
    var deadline : Date? = nil
    var category : CategoriesResponce? = nil
    var priority : PrioritiesResponce? = nil
    var created : Date? = nil
}
