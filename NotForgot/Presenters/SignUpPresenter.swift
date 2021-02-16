//
//  SignUpPresenter.swift
//  NotForgot
//
//  Created by Sergio Ramos on 26.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import UIKit

class SignUpPresenter {
    
    weak private var viewDelegate : SignUpDelegate?
    
    func setViewDelegate(ViewDelegate : SignUpDelegate?) {
        self.viewDelegate = ViewDelegate
    }
    
    func signUp(name : String, mail : String, pass : String, repass : String) {
        if !Checker().isNameValid(name) {
            self.viewDelegate?.showError(title: "Ошибка авторизации", massage: "Все поля должны быть заполнены")
            return
        }
        if !Checker().isMailValid(mail) {
            self.viewDelegate?.showError(title: "Ошибка авторизации", massage: "Неверный логин")
            return
        }
        if !Checker().isPasswordValid(pass) {
            self.viewDelegate?.showError(title: "Ошибка авторизации", massage: "Введите пароль")
            return
        }
        if !Checker().isPassEqual(pass, repass) {
            self.viewDelegate?.showError(title: "Ошибка авторизации", massage: "Пароли не совпадают")
            return
        }
        let user = UserSignUp()
        user.name = name
        user.email = mail
        user.password = pass
        
        AlamofireHelper().signUp(userSignUp: user, { (responce) in
            
            CoreDataHelper().addUser(mail: mail, pass: pass, token: responce.api_token!)

            self.viewDelegate?.openNotes()
        }) { (error) in
            self.viewDelegate?.showError(title: "Ошибка от сервера", massage: error)
        }
    }
    
    func toSignIn() {
        viewDelegate?.openSignIn()
    }
}
