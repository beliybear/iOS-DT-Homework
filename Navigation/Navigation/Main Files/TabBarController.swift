//
//  TabBarController.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import UIKit

class TabBarController: UITabBarController {

    private let profileViewController = Factory(navigationController: UINavigationController(), viewController: .profile)
    private let locationViewController = Factory(navigationController: UINavigationController(), viewController: .location)
    private let likedViewController = Factory(navigationController: UINavigationController(), viewController: .liked)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers()
    }
    
    func viewControllers() {
        viewControllers = [locationViewController.navigationController, likedViewController.navigationController, profileViewController.navigationController]
    }
}
