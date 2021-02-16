//
//  PriorityPresenter.swift
//  NotForgot
//
//  Created by Sergio Ramos on 27.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import CoreData

class PriorityPresenter {
    
    weak private var viewDelegate : PriorityDelegate?
    
    var priorities : [Priority]
    
    init() {
        priorities = CoreDataHelper().getPrioritiesData()
    }
    
    func setViewDelegate(ViewDelegate : PriorityDelegate?) {
        self.viewDelegate = ViewDelegate
    }
}
