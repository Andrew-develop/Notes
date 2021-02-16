//
//  Checker.swift
//  NotForgot
//
//  Created by Sergio Ramos on 29.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation

class Checker {
    
    var isMailValid = { (mail : String) -> Bool in
        if mail.isEmpty {
            return false
        }
        let regExp = "[a-z0-9]+@[a-z0-9]+.[a-z]+"
        let regex = try! NSRegularExpression(pattern: regExp)
        let range = NSRange(location: 0, length: mail.count)
        return regex.firstMatch(in: mail, options: [], range: range) != nil
    }
    
    var isPasswordValid = { (pass : String) -> Bool in
        if pass.isEmpty {
            return false
        }
        return true
    }
    
    var isNameValid = { (name : String) -> Bool in
        if name.isEmpty {
            return false
        }
        return true
    }
    
    var isPassEqual = { (pass : String, rePass : String) -> Bool in
        if pass != rePass {
            return false
        }
        return true
    }
}
