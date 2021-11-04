//
//  AppDelegate.swift
//  Friends
//
//  Created by Emiray Nakip on 3.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .myWhite
        let navigation = UINavigationController()
        let mainView = SignInViewController()
        navigation.viewControllers = [mainView]
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

