//
//  User.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation
import UIKit

class User {
    var name: String
    var avatar: UIImage
    var status: String
    var login: String
    
    init(login: String, name: String, avatar: UIImage, status: String) {
        self.login = login
        self.name = name
        self.avatar = avatar
        self.status = status
    }
}

protocol UserService {
    func authorization(_ login: String) -> User?
}
