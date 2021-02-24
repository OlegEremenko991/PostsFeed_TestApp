//
//  SceneDelegate.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootViewController = MainVC()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }

}

