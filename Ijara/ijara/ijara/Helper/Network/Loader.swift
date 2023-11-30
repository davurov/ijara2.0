//
//  Loader.swift
//  ijara
//
//  Created by Abduraxmon on 18/08/23.
//

import Foundation
import Lottie

public class Loader {
    
    class func start() {
        let loadV = UIView()
        loadV.tag = 1
        loadV.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        loadV.frame = UIScreen.main.bounds
        let customView = LottieAnimationView()
        loadV.addSubview(customView)
        customView.backgroundColor = .clear
        customView.animation = LottieAnimation.named("KKfo9cQRyU")
        customView.animationSpeed = 2.0
        customView.loopMode = .loop
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.centerXAnchor.constraint(equalTo: loadV.centerXAnchor).isActive = true
        customView.centerYAnchor.constraint(equalTo: loadV.centerYAnchor).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        customView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(loadV)
        
        DispatchQueue.main.async {
            customView.play()
        }
    }

    class func stop() {
        guard let subviews =  (UIApplication.shared.delegate as! AppDelegate).window?.subviews else {
            return
        }
        
        for i in subviews {
            if i.tag == 1 {
                i.removeFromSuperview()
            }
        }
    }
}
