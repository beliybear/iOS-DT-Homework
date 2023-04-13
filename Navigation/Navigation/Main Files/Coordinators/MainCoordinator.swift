//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Beliy.Bear on 11.03.2023.
//

import Foundation
import UIKit

protocol MainCoordinator {
    func start() -> UIViewController
}

class MainCoordinatorImp: MainCoordinator {
    func start() -> UIViewController {
        return TabBarController()
    }


}
