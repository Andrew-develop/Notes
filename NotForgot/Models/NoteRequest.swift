//
//  NoteRequest.swift
//  NotForgot
//
//  Created by Sergio Ramos on 13.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation

class NoteRequest : Encodable {
    var title = ""
    var description = ""
    var done : Int16? = nil
    var deadline : Int64? = nil
    var category_id : Int16? = 0
    var priority_id : Int16? = 0
}
