//
//  SignUpViewController.swift
//  NotForgot
//
//  Created by Sergio Ramos on 23/10/2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

protocol SignUpDelegate: NSObjectProtocol {
    func openSignIn()
    func openNotes()
    func showError(title : String, massage : String)
}

class SignUpViewController: UIViewController, SignUpDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var rePass: UITextField!
    
    private let presenter = SignUpPresenter()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        UIButton.appearance().cornerRadius = 8
        hideKeyboardWhenTappedAround()
        presenter.setViewDelegate(ViewDelegate: self)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        presenter.signUp(name: name.text!, mail: mail.text!, pass: pass.text!, repass: rePass.text!)
    }
    
    @IBAction func toSignIn(_ sender: UIButton) {
        presenter.toSignIn()
    }
    
    func openSignIn() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInViewController
        self.dismiss(animated: false, completion: {
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
