//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation
import UIKit
import ServiceStorage

final class ProfileViewModel {
   
    let profileHeaderView = ProfileHeaderView()
    var postsData: [Post] = []
    var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
    }
    
    func setUser() {
        profileHeaderView.setUser(avatar: currentUser.avatar, name: currentUser.name, status: currentUser.status)
    }
    
    func setPosts() {
        postsData = Posts
    }
}
