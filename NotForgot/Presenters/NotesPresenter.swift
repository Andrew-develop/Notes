//
//  NotesPresenter.swift
//  NotForgot
//
//  Created by Sergio Ramos on 26.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import CoreData

protocol NotesViewControllerDelegate: class {
    func updateNotes(note: Note)
    func updateTable()
}

class NotesPresenter: NotesViewControllerDelegate {
    
    weak private var viewDelegate : NotesDelegate?
    
    var notes : [Note]
    var categories : [Category]
    var priorities : [Priority]
    
    init() {
        notes = CoreDataHelper().getNotesData()
        categories = CoreDataHelper().getCategoriesData()
        priorities = CoreDataHelper().getPrioritiesData()
        takePrioritiesFromNet()
        getCategoriesFromNet()
        takeNotesFromNet()
    }
    
    func setViewDelegate(ViewDelegate : NotesDelegate?) {
        self.viewDelegate = ViewDelegate
    }
    
    func updateNotes(note : Note) {
        notes.append(note)
        viewDelegate?.updateTable()
    }
    
    func updateTable() {
        viewDelegate?.updateTable()
    }
    
    func takePrioritiesFromNet() {
        AlamofireHelper().getPriorities { [self] (responce) in
            
            CoreDataHelper().deleteFromCoreData(mass: priorities)
            priorities.removeAll()

            responce?.forEach({ (priority) in
                self.priorities.append(CoreDataHelper().saveNetPriority(id: priority.id!, name: priority.name!))
            })
        } onError: { (error) in
            self.viewDelegate?.showError(title: "Ошибка от сервера", massage: error)
        }
    }
    
    func getCategoriesFromNet() {
        AlamofireHelper().getCategories { [self] (responce) in

            responce?.forEach({ (category) in
                self.categories.append(CoreDataHelper().saveNetCategory(id: category.id!, name: category.name!))
            })
            
        } onError: { (error) in
            self.viewDelegate?.showError(title: "Ошибка от сервера", massage: error)
        }
    }
    
    func takeNotesFromNet() {
        AlamofireHelper().getNotes { [self] (responce) in
            
            CoreDataHelper().deleteFromCoreData(mass: notes)
            notes.removeAll()
            
            responce?.forEach({ (note) in
                let cat = Int((note.category?.id)!)
                let pr = Int((note.priority?.id)!)
                self.notes.append(CoreDataHelper().saveNetNotes(id: note.id!, title: note.title!, description: note.description!, deadline: note.deadline!, category: categories[cat], priority: priorities[pr-2]))
            })
            self.viewDelegate?.updateTable()
        } onError: { (error) in
            self.viewDelegate?.showError(title: "Ошибка от сервера", massage: error)
        }
    }
    
    func logOut() {
        CoreDataHelper().clearCoreData()
        viewDelegate?.openSignIn()
    }
    
    func choiceColor() -> UIColor {
        let colorName = Colors.randomColor()
        if colorName == Colors.yellow {
            return #colorLiteral(red: 1, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        }
        else if colorName == Colors.blue {
            return #colorLiteral(red: 0.3960784314, green: 0.4745098039, blue: 0.9176470588, alpha: 1)
        }
        else if colorName == Colors.green {
            return #colorLiteral(red: 0.3215686275, green: 0.8, blue: 0.3411764706, alpha: 1)
        }
        else if colorName == Colors.red {
            return #colorLiteral(red: 1, green: 0.4078431373, blue: 0.3607843137, alpha: 1)
        }
        return UIColor()
    }
}
