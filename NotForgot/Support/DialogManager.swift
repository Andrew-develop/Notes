//
//  DialogManager.swift
//  NotForgot
//
//  Created by Sergio Ramos on 09.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation
import UIKit

class DialogManager {
    static func showError(controller: UIViewController, title : String?, massage : String?) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
}
