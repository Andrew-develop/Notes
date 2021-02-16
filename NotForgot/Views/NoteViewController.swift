//
//  NoteViewController.swift
//  NotForgot
//
//  Created by Sergio Ramos on 30/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate: class {
    func updateNote(changedNote: Note)
}

class NoteViewController: UIViewController, NoteViewControllerDelegate {
    
    weak var delegateNotes: NotesViewControllerDelegate?
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var kategory: UILabel!
    @IBOutlet weak var noteDescription: UITextView!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var status: UILabel!
    
    var note : Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageInfo()
    }
    
    func updateNote(changedNote: Note) {
        note = changedNote
        pageInfo()
    }
    
    func pageInfo() {
        header.text = note?.name
        noteDescription.text = note?.zamDescription
        noteDescription.isEditable = false
        if note?.deadline != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            deadline.text = "До " + dateFormatter.string(from: (note?.deadline)!)
        }
        if note?.status == false {
            status.text = "В процессе"
        }
        else {
            status.text = "Выполнено"
        }
        status.textColor = #colorLiteral(red: 0.3215686275, green: 0.8, blue: 0.3411764706, alpha: 1)
        kategory.text = note?.category?.name
        priority.text = note?.priority?.name
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "NewZam") as! NewZamViewController
        vc.note = note!
        vc.barName = "Изменить задачу"
        vc.delegateNote = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        delegateNotes?.updateTable()
        self.dismiss(animated: false, completion: nil)
    }
}
