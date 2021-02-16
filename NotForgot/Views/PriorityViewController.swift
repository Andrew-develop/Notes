//
//  PriorityViewController.swift
//  NotForgot
//
//  Created by Sergio Ramos on 30/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

protocol PriorityDelegate: NSObjectProtocol {
    func showError(title : String, massage : String)
    func updateTable()
}

class PriorityViewController: UIViewController, PriorityDelegate {
    
    let presenter = PriorityPresenter()
        
    weak var delegate: NewZamViewControllerDelegate?
        
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(ViewDelegate: self)
    }
        
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(title: String, massage: String) {
        DialogManager.showError(controller: self, title: title, massage: massage)
    }
    
    func updateTable() {
        tableView.reloadData()
    }
}

extension PriorityViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.priorities.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryAndPriority", for: indexPath) as! CatAndPrioTableViewCell
        cell.catOrPrio.text = presenter.priorities[indexPath.row].name
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updatePriority(priority: presenter.priorities[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
