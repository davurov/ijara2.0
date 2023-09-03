//
//  AppDelegate.swift
//  ijara
//
//  Created by Abduraxmon on 24/07/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        FirebaseApp.configure()
        
        window = UIWindow()
        // if user not signed up
        if Auth.auth().currentUser == nil {
            let vc = SingInLangVC(nibName: "SingInLangVC", bundle: nil)
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
        } else {
            //if user signed in
            let vc = CustomTabBar()
            window?.rootViewController = vc
            
        }
        
        API.getProducts { result in
            if let result = result {
                let encoded = JSONEncoder()
                
                if let encoded = try? encoded.encode(result) {
                    UserDefaults.standard.set(encoded, forKey: Keys.houseData)
                }
            }
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}
