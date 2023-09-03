//
//  CustomTabBar.swift
//  ijara
//
//  Created by Muslim on 01/09/23.
//

import UIKit

class CustomTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            generate(viewController: HomeVC(nibName: "HomeVC", bundle: nil),
                     image: UIImage(named: "home"))
        ]
    }
    
    func generate(viewController: UIViewController,
                  title: String? = nil,
                  image: UIImage? = nil,
                  inNav: Bool = false) -> UIViewController{
        
        let vc = inNav ? UINavigationController(rootViewController: viewController) : viewController
        
        vc.tabBarItem.title = title
        vc.tabBarItem.image = image?.withSize(scaledToSize: CGSize(width: 20, height: 20))
        
        return vc
    }
    
    // customize tabBar Appearance
    
    func customizeTabBar() {
        
        
    }
}
