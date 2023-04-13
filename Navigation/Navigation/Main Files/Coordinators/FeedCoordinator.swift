//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation
import UIKit

final class FeedCoordinator {
    
    var navigationController: UINavigationController!

    func pushPostViewController() {
        let viewControllerToPush = PostViewController()
        navigationController.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushInfoViewController() {
        let viewControllerToPush = InfoViewController()
        navigationController.pushViewController(viewControllerToPush, animated: true)
    }
    
}
