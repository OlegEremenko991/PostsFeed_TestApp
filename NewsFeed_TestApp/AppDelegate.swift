//
//  AppDelegate.swift
//  NewsFeed_TestApp
//
//  Created by Олег Еременко on 21.09.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainVC())
        window?.makeKeyAndVisible()
        
        return true
    }

}

