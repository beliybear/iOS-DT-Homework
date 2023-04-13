//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation
import UIKit

class ProfileCoordinator {
 
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startView(user: User) {
        let photoCoordinator = PhotoCoordinator(navigationController: navigationController)
        let profileViewModel = ProfileViewModel(currentUser: user)
        let profileViewController = ProfileViewController(photoCoordinator: photoCoordinator, profileViewModel: profileViewModel)
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func pushPhotoViewController() {
        let photosViewController = PhotosViewController()
        navigationController.pushViewController(photosViewController, animated: true)
    }
}
