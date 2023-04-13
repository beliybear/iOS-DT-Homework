//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation

protocol LoginViewControllerDelegate {
    func check(_ login: String, _ password: String) -> Bool
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}

struct LoginInspector: LoginViewControllerDelegate {
    func check(_ login: String, _ password: String) -> Bool {
        return Checker.shared.check(login, password)
    }
}

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}
