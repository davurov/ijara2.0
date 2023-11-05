//
//  Loader.swift
//  ijara
//
//  Created by Abduraxmon on 18/08/23.
//

import Foundation
import Lottie


public class Loader {
    
    ///Shows custom Alert for a while
    class func start() {
        print("Loader started")
        let loadV = UIView()
        loadV.backgroundColor = .red
        loadV.tag = 19995
        loadV.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        loadV.frame = UIScreen.main.bounds
        let customView = LottieAnimationView()
        customView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        
        loadV.addSubview(customView)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.centerXAnchor.constraint(equalTo: loadV.centerXAnchor).isActive = true
        customView.centerYAnchor.constraint(equalTo: loadV.centerYAnchor).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        customView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        
        
        customView.backgroundColor = .clear
        (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(loadV)
        customView.animation = LottieAnimation.named("KKfo9cQRyU")
        customView.animationSpeed = 2.0
        customView.loopMode = .loop
        DispatchQueue.main.async {
            customView.play()
        }
    }
    
    class func stop() {
        print("Loader stoped")
        
        guard let d =  (UIApplication.shared.delegate as! AppDelegate).window?.subviews else {
            return
        }
        for i in d {
            if i.tag == 19995 {
//                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
//                    i.backgroundColor = .clear
//                } completion: { (_) in
                    i.removeFromSuperview()
//                }
            }
        }
    }
}
