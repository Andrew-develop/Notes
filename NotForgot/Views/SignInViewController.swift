//
//  SignInViewController.swift
//  NotForgot
//
//  Created by Sergio Ramos on 25/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

protocol SignInDelegate: NSObjectProtocol {
    func openSignUp()
    func openNotes()
    func showError(title : String, massage : String)
}

class SignInViewController: UIViewController, SignInDelegate {
    
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    private let presenter = SignInPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIButton.appearance().cornerRadius = 8
        hideKeyboardWhenTappedAround()
        presenter.setViewDelegate(ViewDelegate: self)
    }

    @IBAction func signIn(_ sender: UIButton) {
        presenter.signIn(mail: mail.text!, pass: pass.text!)
    }
    
    @IBAction func toSignUp(_ sender: UIButton) {
        presenter.toSignUp()
    }
    
    func openSignUp() {
        let vc = storyboard?.instantiateViewController(identifier: "signUp") as! SignUpViewController
        self.dismiss(animated: true, completion: {
            self.present(vc, animated: true, completion: nil)
        })
    }
    
    func openNotes() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "notes") as! NotesViewController
        self.dismiss(animated: false, completion: {
            self.present(vc, animated: true, completion: nil)
        })
    }
    
    func showError(title : String, massage : String) {
        DialogManager.showError(controller: self, title: title, massage: massage)
    }
}
