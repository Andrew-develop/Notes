//
//  NotesViewController.swift
//  NotForgot
//
//  Created by Sergio Ramos on 30/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

protocol NotesDelegate: NSObjectProtocol {
    func updateTable()
    func openSignIn()
    func showError(title : String, massage : String)
}

class NotesViewController: UIViewController, NotesDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newNoteButton: UIButton!
    
    let presenter = NotesPresenter()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(ViewDelegate: self)
        refreshControl.attributedTitle = NSAttributedString(string: "Что-то новенькое?")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        presenter.logOut()
    }
    
    @IBAction func newNote(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "NewZam") as! NewZamViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        vc.note = Note(context: context)
        vc.delegateNotes = presenter
        vc.barName = "Новая задача"
        present(vc, animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        presenter.takeNotesFromNet()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func showError(title: String, massage: String) {
        DialogManager.showError(controller: self, title: title, massage: massage)
    }
    
    func openSignIn() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInViewController
        self.dismiss(animated: false, completion: {
            self.present(vc, animated: true, completion: nil)
        })
    }
}


extension NotesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.notes.count == 0 {
            return 1
        }
        else {
            newNoteButton.isHidden = false
            return presenter.notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.notes.count == 0 {
            newNoteButton.isHidden = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "noNotes", for: indexPath) as! NoNotesTableViewCell
            cell.addButton.layer.cornerRadius = 8
            cell.addButton.addTarget(self, action: #selector(addButtonClicked(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
            cell.header.text = presenter.notes[indexPath.row].name
            cell.headerTwo.text = presenter.notes[indexPath.row].zamDescription
            if presenter.notes[indexPath.row].status == false {
                cell.checkButton.setImage(UIImage(named: "inProgress"), for: .normal)
            }
            else {
                cell.checkButton.setImage(UIImage(named: "Complete"), for: .normal)
            }
            cell.checkButton.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            cell.checkButton.tag = indexPath.row
            cell.view.layer.cornerRadius = 8
            cell.view.backgroundColor = presenter.choiceColor()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if presenter.notes.count == 0 {
            return 600
        }
        else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "note") as! NoteViewController
        vc.note = presenter.notes[indexPath.row]
        vc.delegateNotes = presenter
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AlamofireHelper().deleteNote(note_id: presenter.notes[indexPath.row].note_id, { (responce) in
                print(responce)
            }) { (error) in
                DialogManager.showError(controller: self, title: "Ошибка от сервера", massage: error)
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(presenter.notes[indexPath.row])
            presenter.notes.remove(at: indexPath.row)
            appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func buttonClicked(sender : UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if sender.imageView?.image == UIImage(named: "inProgress") {
            sender.setImage(UIImage(named: "Complete"), for: .normal)
            presenter.notes[sender.tag].status = true
            appDelegate.saveContext()
        }
        else {
            sender.setImage(UIImage(named: "inProgress"), for: .normal)
            presenter.notes[sender.tag].status = false
            appDelegate.saveContext()
        }
    }
    
    @objc func addButtonClicked(sender : UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewZam") as! NewZamViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newNote = Note(context: context)
        vc.note = newNote
        vc.delegateNotes = presenter
        vc.barName = "Новая задача"
        present(vc, animated: true, completion: nil)
    }
}
