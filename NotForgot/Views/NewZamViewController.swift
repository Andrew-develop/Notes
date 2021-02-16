//
//  NewZamViewController.swift
//  NotForgot
//
//  Created by Sergio Ramos on 20/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import CoreData

protocol NewZamViewControllerDelegate: class {
    func updateCategory(category: Category)
    func updatePriority(priority: Priority)
}

class NewZamViewController: UIViewController, UITextFieldDelegate, NewZamViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var note : Note?
    
    weak var delegateNotes: NotesViewControllerDelegate?
    weak var delegateNote: NoteViewControllerDelegate?
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var topTable: UITableView!
    @IBOutlet weak var underTableView: UITableView!
    @IBOutlet weak var datePickerBar: UINavigationBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var barName = ""
    
    let data = ["Срок выполнения задачи","Категория задачи","Приоритет"]
    let field = [1,2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        header.topItem?.title = barName
        datePicker.minimumDate = Date()
    }
    
    func updateCategory(category: Category) {
        note?.category = category
        appDelegate.saveContext()
        underTableView.reloadData()
    }
    
    func updatePriority(priority: Priority) {
        note?.priority = priority
        appDelegate.saveContext()
        underTableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            note?.name = textField.text!
        }
        else if textField.tag == 1 {
            note?.zamDescription = textField.text!
        }
    }
    
    @IBAction func datePickerClose(_ sender: UIBarButtonItem) {
        datePickerBar.isHidden = true
        datePicker.isHidden = true
    }
    
    
    @IBAction func datePickerOk(_ sender: UIBarButtonItem) {
        datePickerBar.isHidden = true
        datePicker.isHidden = true
        note?.deadline = datePicker.date
        underTableView.reloadData()
    }
    
    
    
    @IBAction func noteSave(_ sender: UIBarButtonItem) {
        if note?.name != "" && note?.zamDescription != "" {

            note?.status = false
            appDelegate.saveContext()
            print("Object Saved")
            
            let newNote = NoteRequest()
            if note!.category != nil {
                newNote.category_id = (note?.category?.category_id)!
            }
            if note?.priority != nil {
                newNote.priority_id = (note?.priority?.priority_id)!
            }
            newNote.title = (note?.name)!
            newNote.description = (note?.zamDescription)!
            newNote.deadline = Int64((note?.deadline!.timeIntervalSince1970)!-978307200)
            newNote.done = 1
            
            if barName == "Новая задача" {
                AlamofireHelper().postNote(note: newNote, { (responce) in
                    self.note?.note_id = responce.id!
                }) { (error) in
                    DialogManager.showError(controller: self, title: "Ошибка от сервера", massage: error)
                }

                delegateNotes?.updateNotes(note: note!)
                self.dismiss(animated: true, completion: nil)
            }
            else if barName == "Изменить задачу" {

                appDelegate.saveContext()
                print("Object Changed")
                
                AlamofireHelper().patchNote(note_id: note!.note_id, note: newNote) { (responce) in
                    print("Object changed at net")
                } onError: { (error) in
                    DialogManager.showError(controller: self, title: "Ошибка от сервера", massage: error)
                }

                delegateNote?.updateNote(changedNote: note!)
                self.dismiss(animated: false, completion: nil)
            }
        }
        else {
            DialogManager.showError(controller: self, title: "Ошибка", massage: "Верхние поля должны быть заполнены!")
        }
    }
    
    
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        if barName == "Новая задача" {
            self.dismiss(animated: false, completion: nil)
        }
        else if barName == "Изменить задачу" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "note") as! NoteViewController
            vc.note = note
            self.dismiss(animated: false, completion: {
                self.present(vc, animated: true, completion: nil)
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 120
    }
}

extension NewZamViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.restorationIdentifier == "WriteName" {
            return field.count
        }
        if tableView.restorationIdentifier == "ChooseSettings" {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.restorationIdentifier == "ChooseSettings" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewZamCell", for: indexPath) as! NewZamTableViewCell
            cell.typeNeed.text = data[indexPath.row]
            if data[indexPath.row] == "Срок выполнения задачи" && note?.deadline != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                cell.status.text = "До \(dateFormatter.string(from: (note?.deadline)!))"
            }
            else if data[indexPath.row] == "Категория задачи" && note?.category != nil {
                cell.status.text = note!.category?.name
            }
            else if data[indexPath.row] == "Приоритет" && note?.category != nil {
                cell.status.text = note?.priority?.name
            }
            return cell
        }
        if tableView.restorationIdentifier == "WriteName" {
            if field[indexPath.row] == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameZamTableViewCell
                if note != nil {
                    cell.name.text = note?.name
                }
                cell.name.delegate = self
                cell.name.tag = 0
                cell.selectionStyle = .none
                return cell
            }
            if field[indexPath.row] == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionZamTableViewCell
                if note != nil {
                    cell.descriptionField.text = note?.zamDescription
                }
                cell.descriptionField.delegate = self
                cell.descriptionField.tag = 1
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.restorationIdentifier == "ChooseSettings" {
            return 44
        }
        if tableView.restorationIdentifier == "WriteName" {
            if field[indexPath.row] == 1 {
                return 44
            }
            if field[indexPath.row] == 2 {
                return 167
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.restorationIdentifier == "ChooseSettings" {
            if data[indexPath.row] == "Срок выполнения задачи" {
                datePickerBar.isHidden = false
                datePicker.isHidden = false
            }
            else if data[indexPath.row] == "Категория задачи" {
                let vc = storyboard?.instantiateViewController(identifier: "Category") as! CategoryViewController
                vc.delegate = self
                present(vc, animated: true, completion: nil)
            }
            else {
                let vc = storyboard?.instantiateViewController(identifier: "Priority") as! PriorityViewController
                vc.delegate = self
                present(vc, animated: true, completion: nil)
            }
        }
    }
}
