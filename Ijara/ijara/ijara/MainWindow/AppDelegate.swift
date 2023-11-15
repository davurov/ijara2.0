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
        
//        API.getProducts { houses in
//            var allVillasID: [Int] = []
//            guard let villas = houses else { return }
//            for villa in villas {
//                allVillasID.append(villa.id)
//            }
//            UserDefaults.standard.set(allVillasID, forKey: Keys.allVillas_Id)
//        }
        
        window = UIWindow()
        // if user not signed up
        let token = UserDefaults.standard.string(forKey: Keys.token)
        if Auth.auth().currentUser == nil {
            let vc = SingInLangVC(nibName: "SingInLangVC", bundle: nil)
            let nav = UINavigationController(rootViewController: vc)
            window?.rootViewController = nav
        } else {
            //if user signed in
            let vc = CustomTabBar()
            window?.rootViewController = vc
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}

