//
//  KategoryViewController.swift
//  NotForgot
//
//  Created by Sergio Ramos on 27/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

protocol CategoryDelegate: NSObjectProtocol {
    func showAlert(alert : UIAlertController)
    func showError(title : String, massage : String)
    func updateTable()
}

class CategoryViewController: UIViewController, CategoryDelegate {
    
    weak var delegate: NewZamViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    let presenter = CategoryPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setViewDelegate(ViewDelegate: self)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        presenter.openAlert()
    }
    
    @IBAction func closeButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(title: String, massage: String) {
        DialogManager.showError(controller: self, title: title, massage: massage)
    }
    
    func updateTable() {
        tableView.reloadData()
    }
}

extension CategoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryAndPriority", for: indexPath) as! CatAndPrioTableViewCell
        cell.catOrPrio.text = presenter.categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateCategory(category: presenter.categories[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
