//
//  User.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import UIKit
import FirebaseAuth

enum Autorization {
    case logIn
    case signUp
}

protocol LoginFactoryProtocol {
    func makeCheckerService() -> LoginInspector
}

struct MyLoginFactory: LoginFactoryProtocol {
    func makeCheckerService() -> LoginInspector {
        LoginInspector()
    }
}

protocol LoginDelegateProtocol {
    func logIn(logIn: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void)
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void)
}

struct LoginInspector: LoginDelegateProtocol {
    func logIn(logIn: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void) {
        CheckerService().checkCredentials(email: logIn, password: password) { autorizationData, autorizattionError in
            completion(autorizationData, autorizattionError)
        }
    }
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void) {
        CheckerService().signUp(email: email, password: password, passwordConfirmation: passwordConfirmation) { autorizationData, autorizattionError in
            completion(autorizationData, autorizattionError)
        }
    }
}


protocol CheckerServiceProtocol {
    func checkCredentials(email: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void)
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void)
}

class CheckerService: CheckerServiceProtocol {
    init() {}
    func checkCredentials(email: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void) {
        guard let mail = email, mail != "", let pass = password, pass != "" else {
            completion(nil, .emptyPasswordOrEmail)
            return
        }
        Auth.auth().signIn(withEmail: mail, password: pass) { authDataResult, error in
            if error != nil {
                completion(nil, .invalidPassword)
                return
            }
            if authDataResult?.user != nil {
                completion(.logIn, nil)
            } else {
                completion(nil, .unexpected)
                return
            }
        }
    }
    
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: Authorization?) -> Void) {
        guard let mail = email, mail != "", let pass = password, pass != "", let passConf = passwordConfirmation, passConf != "" else {
            completion(nil, .emptyPasswordOrEmail)
            return
        }
        
        if pass != passConf {
            completion(nil, .mismatchPassword)
            return
        }
        
        Auth.auth().createUser(withEmail: mail, password: pass) { authDataResult, error in
            if let error = error {
                print(error.localizedDescription)
                let err = error as NSError
                
                switch err.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(nil, .emailAlreadyInUse)
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(nil, .invalidEmail)
                case AuthErrorCode.weakPassword.rawValue:
                    completion(nil, .weakPassword)
                default:
                    print(error.localizedDescription)
                }
            } else {
                completion(.signUp, nil)
            }
        }
    }
}

class User {
    var login: String
    var name: String
    var avatar: UIImage
    var status: String
    init(login: String, name: String, avatar: UIImage, status: String) {
        self.login = login
        self.name = name
        self.avatar = avatar
        self.status = status
    }
}
