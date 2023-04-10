//
//  Checker.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation

class Checker {
    
    static let shared = Checker()
        private init() {
            login = "0000"
            password = "1234"
        }

    private let login: String
    private let password: String
    
    func check(_ userLogin: String, _ userPassword: String) -> Bool {
        return userLogin == login && userPassword == password
    }
    
}
