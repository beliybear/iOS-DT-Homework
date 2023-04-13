//
//  TabBarController.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import UIKit

class TabBarController: UITabBarController {

    private let profileViewController = Factory(navigationController: UINavigationController(), viewController: .profile)
    private let feedViewController = Factory(navigationController: UINavigationController(), viewController: .feed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers()
    }
    
    func viewControllers() {
        viewControllers = [feedViewController.navigationController, profileViewController.navigationController]
    }
}
