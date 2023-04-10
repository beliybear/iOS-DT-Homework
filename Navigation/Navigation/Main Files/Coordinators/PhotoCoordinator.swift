//
//  PhotoCoordinator.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation
import UIKit

class PhotoCoordinator {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func startView() {
        
        let photosViewController = PhotosViewController()
        photosViewController.title = "Photo Gallery"
        navigationController.pushViewController(photosViewController, animated: true)
    }
}
