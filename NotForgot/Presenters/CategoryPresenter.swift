//
//  CategoryPresenter.swift
//  NotForgot
//
//  Created by Sergio Ramos on 27.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit
import CoreData

class CategoryPresenter {
    
    weak private var viewDelegate : CategoryDelegate?
    
    var categories : [Category]
    
    init() {
        categories = CoreDataHelper().getCategoriesData()
    }
    
    func setViewDelegate(ViewDelegate : CategoryDelegate?) {
        self.viewDelegate = ViewDelegate
    }
    
    func openAlert() {
        let alert = UIAlertController(title: "Добавить категорию задачи", message: "Название должно кратко отражать суть категории", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        let close = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alert.addAction(close)
        
        let action = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if !alert.textFields![0].text!.isEmpty {
                self.createNewCat(text: alert.textFields![0].text!)
            }
        }
        alert.addAction(action)
        viewDelegate?.showAlert(alert: alert)
    }
    
    func createNewCat(text : String) {

        let possibleCategory = CreateNewCategory()
        possibleCategory.name = text

        AlamofireHelper().postCategory(category: possibleCategory, { (responce) in
            self.categories.append(CoreDataHelper().saveNetCategory(id: responce.id!, name: responce.name!))
        }) { (error) in
            self.viewDelegate?.showError(title: "Ошибка от сервера", massage: error)
        }
    }
}
