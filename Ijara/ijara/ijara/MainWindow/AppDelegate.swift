//
//  AppDelegate.swift
//  ijara
//
//  Created by Abduraxmon on 24/07/23.
//

import UIKit
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared().isEnabled = true
        
        window = UIWindow()
        /// If user firs time entered to app , `isFirstTime` will equal to false. Because  default value of `isFirstTime` is false and befor get values, we did not set any value yet.
        let isFirstTime = UserDefaults.standard.bool(forKey: Keys.isUserEnteredFirstTime)
        
        if !isFirstTime {
            let vc = SingInLangVC(nibName: "SingInLangVC", bundle: nil)
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
        } else {
            let vc = CustomTabBar()
            window?.rootViewController = vc
        }

        window?.makeKeyAndVisible()
        return true
    }
    
}

