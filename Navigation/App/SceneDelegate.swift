//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Ian Belyakov on 29.07.2023
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            return
        }

        let factory = AppFactory()
        let appCoordinator = AppCoordinator(factory: factory)

        self.window = UIWindow(windowScene: scene)
        self.appCoordinator = appCoordinator

        window?.rootViewController = appCoordinator.start()
        window?.makeKeyAndVisible()
    }


}

