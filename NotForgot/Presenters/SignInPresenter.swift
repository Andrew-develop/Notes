//
//  SignInPresenter.swift
//  NotForgot
//
//  Created by Sergio Ramos on 25.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

class SignInPresenter {
    
    weak private var viewDelegate : SignInDelegate?
    
    func setViewDelegate(ViewDelegate : SignInDelegate?) {
        self.viewDelegate = ViewDelegate
    }
    
    func toSignUp() {
        viewDelegate?.openSignUp()
    }
    
    func signIn(mail : String, pass : String) {
        if !Checker().isMailValid(mail) {
            self.viewDelegate?.showError(title: "Ошибка авторизации", massage: "Неверный логин")
            return
        }
        if !Checker().isPasswordValid(pass) {
            self.viewDelegate?.showError(title: "Ошибка авторизации", massage: "Введите пароль")
            return
        }
        let user = UserSignIn()
        user.email = mail
        user.password = pass
        
        AlamofireHelper().signIn(userSignIn: user, { (responce) in
            
            CoreDataHelper().addUser(mail: mail, pass: pass, token: responce.api_token!)

            self.viewDelegate?.openNotes()
        }) { (error) in
            self.viewDelegate?.showError(title: "Ошибка от сервера", massage: error)
        }
    }
}
