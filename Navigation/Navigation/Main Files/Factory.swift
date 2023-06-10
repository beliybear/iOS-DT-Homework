//
// Factory.swift
// Navigation
//
// Created by Beliy.Bear on 11.03.2023.
//
import Foundation
import UIKit

class Factory {
    enum Views {
        case profile
        case feed
        case liked
        case location
    }
    
    let navigationController: UINavigationController
    let viewController: Views
    
    init(navigationController: UINavigationController, viewController: Views) {
        self.navigationController = navigationController
        self.viewController = viewController
        startModule()
    }
    
    private func startModule() {
        switch viewController {
        case .profile:
            let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
            let controller = LoginViewController(coordinator: profileCoordinator)
            controller.logInDelegate = MyLoginFactory().makeCheckerService()
            navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 2)
            navigationController.setViewControllers([controller], animated: true)
            
        case .feed:
            let feedCoordinator = FeedCoordinator()
            let controller = FeedViewController(coordinator: feedCoordinator)
            navigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "doc.richtext"), tag: 0)
            navigationController.setViewControllers([controller], animated: true)
            
        case .liked:
            let controller = LikedPostsViewController()
            navigationController.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart"), tag: 1)
            navigationController.setViewControllers([controller], animated: true)
            
        case .location:
            let controller = LocationViewController()
            navigationController.tabBarItem = UITabBarItem(title: "Location", image: UIImage(systemName: "location"), tag: 0)
            navigationController.setViewControllers([controller], animated: true)
            
        }
    }
}
