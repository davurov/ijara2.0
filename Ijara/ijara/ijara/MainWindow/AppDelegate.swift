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
                guard !result.isEmpty else {return}
                
                let encoded = JSONEncoder()
                
                if let encoded = try? encoded.encode(result) {
                    UserDefaults.standard.set(encoded, forKey: Keys.houseData)
                }
            }
        }
        
        // set up liked house data
        if UserDefaults.standard.array(forKey: Keys.likedHouses) == nil{
            let defVal = [String]()
            UserDefaults.standard.set(defVal, forKey: Keys.likedHouses)
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}

