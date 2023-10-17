//
//  CustomTabBar.swift
//  ijara
//
//  Created by Muslim on 01/09/23.
//

import UIKit

final class CustomTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createMenuViewController(),
                           createContactViewController(),
                           createProfileViewController()]
        
        tabBar.tintColor = AppColors.selectedTabbarCollor
        tabBar.backgroundColor = AppColors.tabBarBack
    }
}

private extension CustomTabBar {
    
    func createMenuViewController() -> UIViewController {
        let vc = HomeVC()
        let image = SFSymbols.TabBarSymbols.homeSymbol
        vc.tabBarItem = UITabBarItem(title: SetLanguage.setLang(type: .menu),
                                     image: image,
                                     tag: 0)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createContactViewController() -> UIViewController {
        let vc = LikedHousesVC()
        let image = SFSymbols.TabBarSymbols.heartSymbol
        vc.tabBarItem = UITabBarItem(title: SetLanguage.setLang(type: .liked),
                                     image: image,
                                     tag: 1)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createProfileViewController() -> UIViewController {
        let vc = ProfileVC()
        let image = SFSymbols.TabBarSymbols.profileSymbol
        vc.tabBarItem = UITabBarItem(title: SetLanguage.setLang(type: .profileTitle),
                                     image: image,
                                     tag: 2)
        
        return UINavigationController(rootViewController: vc)
    }
}
