//
//  CustomTabBar.swift
//  ijara
//
//  Created by Muslim on 01/09/23.
//

import UIKit

final class CustomTabBar: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createMenuViewController(),
                           createChildrensPartyViewController(),
                           createTaxiViewController(),
                           createContactViewController(),
                           createProfileViewController()
                          ]
        
        tabBar.tintColor = AppColors.selectedTabbarCollor
        tabBar.backgroundColor = AppColors.tabBarBack
        
        delegate = self
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 3 || item.tag == 4 {
            tabBar.backgroundColor = .systemGray6
            tabBar.barTintColor = .systemGray6
        } else {
            tabBar.backgroundColor = .white
            tabBar.barTintColor = .white
        }
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
    
    func createChildrensPartyViewController() -> UIViewController {
        let vc = ChildrensServiceVC()
        let image = SFSymbols.TabBarSymbols.childrensParty
        vc.tabBarItem = UITabBarItem(title: SetLanguage.setLang(type: .childrens),
                                     image: image,
                                     tag: 1)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createTaxiViewController() -> UIViewController {
        let vc = TaxiServiceVC()
        let image = SFSymbols.TabBarSymbols.taxiTabbarSymbol
        vc.tabBarItem = UITabBarItem(title: SetLanguage.setLang(type: .taxi),
                                     image: image,
                                     tag: 2)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createContactViewController() -> UIViewController {
        let vc = LikedHousesVC()
        let image = SFSymbols.TabBarSymbols.heartSymbol
        vc.tabBarItem = UITabBarItem(title: SetLanguage.setLang(type: .wishlists),
                                     image: image,
                                     tag: 3)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createProfileViewController() -> UIViewController {
        let vc = ProfileViewController()
        let image = SFSymbols.TabBarSymbols.profileSymbol
        vc.tabBarItem = UITabBarItem(title: SetLanguage.setLang(type: .profileTitle),
                                     image: image,
                                     tag: 4)
        
        return UINavigationController(rootViewController: vc)
    }
}

