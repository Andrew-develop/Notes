//
//  AlamofireHelper.swift
//  NotForgot
//
//  Created by Sergio Ramos on 11.11.2020.
//  Copyright © 2020 Sergio Ramos. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class AlamofireHelper {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let baseURL = "http://practice.mobile.kreosoft.ru/api/"
    var user = User()
    
    func stateUser()  {
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<User> = User.fetchRequest()
        let result = try! context.fetch(request) as [User]
        self.user = result[0]
    }
    
    func signIn(userSignIn: UserSignIn, _ onComplete: @escaping (_ signInResponse: SignInResponce) -> Void, onError:  @escaping (_ message: String) -> Void) {
        
        AF.request(baseURL + "login",
                   method: .post,
                   parameters: userSignIn,
                   encoder: JSONParameterEncoder.default).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode(SignInResponce.self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    func signUp(userSignUp: UserSignUp, _ onComplete: @escaping (_ signUpResponse: SignUpResponce) -> Void, onError:  @escaping (_ message: String) -> Void) {
        
        AF.request(baseURL + "register",
                   method: .post,
                   parameters: userSignUp,
                   encoder: JSONParameterEncoder.default).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode(SignUpResponce.self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    func getPriorities(_ onComplete: @escaping (_ priorities: [PrioritiesResponce]?) -> Void, onError:  @escaping (_ message: String) -> Void) {
        stateUser()
        
        let httpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(user.token!)",  "Accept": "application/json"]
        AF.request(baseURL + "priorities",
                   method: .get,
                   encoding: URLEncoding(destination: .queryString),
                   headers: httpHeaders).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode([PrioritiesResponce].self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    func getCategories(_ onComplete: @escaping (_ priorities: [CategoriesResponce]?) -> Void, onError:  @escaping (_ message: String) -> Void) {
        stateUser()
        
        let httpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(user.token!)",  "Accept": "application/json"]
        AF.request(baseURL + "categories",
                   method: .get,
                   encoding: URLEncoding(destination: .queryString),
                   headers: httpHeaders).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode([CategoriesResponce].self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    
    func getNotes(_ onComplete: @escaping (_ priorities: [NotesResponce]?) -> Void, onError:  @escaping (_ message: String) -> Void) {
        stateUser()
        
        let httpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(user.token!)",  "Accept": "application/json"]
        AF.request(baseURL + "tasks",
                   method: .get,
                   encoding: URLEncoding(destination: .queryString),
                   headers: httpHeaders).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode([NotesResponce].self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    func postCategory (category: CreateNewCategory, _ onComplete: @escaping (_ signInResponse: CreateCategoryResponce) -> Void, onError:  @escaping (_ message: String) -> Void) {
        stateUser()
        
        let httpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(user.token!)",  "Accept": "application/json"]
        
        AF.request(baseURL + "categories",
                   method: .post,
                   parameters: category,
                   encoder: JSONParameterEncoder.default,
                   headers: httpHeaders).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode(CreateCategoryResponce.self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    func postNote (note: NoteRequest, _ onComplete: @escaping (_ signInResponse: NoteResponce) -> Void, onError:  @escaping (_ message: String) -> Void) {
        stateUser()
        
        let httpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(user.token!)",  "Accept": "application/json"]
        
        AF.request(baseURL + "tasks",
                   method: .post,
                   parameters: note,
                   encoder: JSONParameterEncoder.default,
                   headers: httpHeaders).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode(NoteResponce.self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    func deleteNote(note_id : Int16, _ onComplete: @escaping (_ message: Int8) -> Void, onError:  @escaping (_ message: String) -> Void) {
        stateUser()
        
        let httpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(user.token!)",  "Accept": "application/json"]
        AF.request(baseURL + "tasks/\(note_id)",
                   method: .delete,
                   encoding: URLEncoding(destination: .queryString),
                   headers: httpHeaders).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(Int8(data![0]))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
    
    func patchNote (note_id : Int16, note: NoteRequest, _ onComplete: @escaping (_ signInResponse: NoteResponce) -> Void, onError:  @escaping (_ message: String) -> Void) {
        stateUser()
        
        let httpHeaders: HTTPHeaders = ["Authorization" : "Bearer \(user.token!)",  "Accept": "application/json"]
        
        AF.request(baseURL + "tasks/\(note_id)",
                   method: .patch,
                   parameters: note,
                   encoder: JSONParameterEncoder.default,
                   headers: httpHeaders).response { response in
                    switch response.result {
                    case .success(let data):
                        onComplete(try! JSONDecoder().decode(NoteResponce.self, from: data!))
                    case .failure(let error):
                        onError(error.errorDescription ?? "")
                    }
        }
    }
}
