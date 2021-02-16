//
//  SignUpResponce.swift
//  NotForgot
//
//  Created by Sergio Ramos on 11.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation

class SignUpResponce: Decodable {
    var email : String? = nil
    var name : String? = nil
    var id : Int? = nil
    var api_token : String? = nil
}
