//
//  TestUserService.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation
import UIKit

class TestUserService: UserService {
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func authorization(_ login: String) -> User? {
        return user.login == login ? user : nil
    }
}
