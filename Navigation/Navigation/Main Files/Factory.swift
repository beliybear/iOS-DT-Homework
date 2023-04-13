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
            controller.loginDelegate = MyLoginFactory().makeLoginInspector()
            navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)
            navigationController.setViewControllers([controller], animated: true)

        case .feed:
            let feedCoordinator = FeedCoordinator()
            let controller = FeedViewController(coordinator: feedCoordinator)
            navigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "doc.richtext"), tag: 0)
            navigationController.setViewControllers([controller], animated: true)
        }
    }
}
