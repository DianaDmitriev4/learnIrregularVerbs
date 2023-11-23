//
//  AppDelegate.swift
//  learnIrregularVerbs
//
//  Created by User on 20.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window {
            let navigationController = UINavigationController()
            navigationController.viewControllers = [HomeViewController()]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        return true
    }
    
}
