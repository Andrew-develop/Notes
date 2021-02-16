//
//  CoreDataHelper.swift
//  NotForgot
//
//  Created by Sergio Ramos on 29.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func addUser(mail : String, pass : String, token : String) {
        let context = appDelegate.persistentContainer.viewContext
        
        let userCD = User(context: context)
        userCD.mail = mail
        userCD.pass = pass
        userCD.token = token
        
        appDelegate.saveContext()
    }
    
    func saveNetCategory(id : Int16, name : String) -> Category {
        let context = appDelegate.persistentContainer.viewContext
        
        let newCategory = Category(context: context)
        newCategory.category_id = id
        newCategory.name = name
        
        appDelegate.saveContext()
        return newCategory
    }
    
    func getCategoriesData() -> [Category] {
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        let result = try! context.fetch(request) as [Category]
        
        return result
    }
    
    func saveNetPriority(id : Int16, name : String) -> Priority {
        let context = appDelegate.persistentContainer.viewContext
        
        let newPriority = Priority(context: context)
        newPriority.priority_id = id
        newPriority.name = name
        
        appDelegate.saveContext()
        return newPriority
    }
    
    func getPrioritiesData() -> [Priority] {
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<Priority> = Priority.fetchRequest()
        let result = try! context.fetch(request) as [Priority]
        
        return result
    }
    
    func saveNetNotes(id : Int16, title : String, description : String, deadline : Date, category : Category, priority : Priority) -> Note {
        let context = appDelegate.persistentContainer.viewContext
        
        let newNote = Note(context: context)
        newNote.note_id = id
        newNote.name = title
        newNote.zamDescription = description
        newNote.deadline = deadline
        newNote.category = category
        newNote.priority = priority
        
        appDelegate.saveContext()
        
        return newNote
    }
    
    func getNotesData() -> [Note] {
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let result = try! context.fetch(request) as [Note]
        
        return result
    }
    
    func deleteFromCoreData<T : NSManagedObject>(mass : [T]) {
        let context = appDelegate.persistentContainer.viewContext
        
        mass.forEach { (element) in
            context.delete(element)
        }
        appDelegate.saveContext()
    }
    
    func clearCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        
        let requestNotes : NSFetchRequest<Note> = Note.fetchRequest()
        let resultNotes = try! context.fetch(requestNotes) as [Note]
        
        let requestUser : NSFetchRequest<User> = User.fetchRequest()
        let resultUser = try! context.fetch(requestUser) as [User]
        
        let requestPrio : NSFetchRequest<Priority> = Priority.fetchRequest()
        let resultPrio = try! context.fetch(requestPrio) as [Priority]
        
        let requestKat : NSFetchRequest<Category> = Category.fetchRequest()
        let resultKat = try! context.fetch(requestKat) as [Category]
        
        resultNotes.forEach { (note) in
            context.delete(note)
        }
        resultUser.forEach { (user) in
            context.delete(user)
        }
        resultPrio.forEach { (prio) in
            context.delete(prio)
        }
        resultKat.forEach { (kat) in
            context.delete(kat)
        }
        appDelegate.saveContext()
    }
}
