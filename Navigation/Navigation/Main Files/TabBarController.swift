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
        
        UITabBar.appearance().tintColor = UIColor.createColor(lightMode: .systemBlue, darkMode: .white)
        UITabBar.appearance().backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        
        viewControllers()
    }
    
    func viewControllers() {
        viewControllers = [locationViewController.navigationController, likedViewController.navigationController, profileViewController.navigationController]
    }
}
