//
//  Alert.swift
//  ijara
//
//  Created by Abduraxmon on 14/08/23.
//

import Foundation
import UIKit

let screenSize = UIScreen.main.bounds

class Alert {
    
    enum AlertType {
        case warning
        case success
        case error
        case unknown
        case clear
    }
    
    static var timer : Timer? = nil
    
    class func showAlert(forState: AlertType, message: String, duration: TimeInterval = 4, userInteration: Bool = true) {
                
        let view = UIView(frame: CGRect(x: 10, y: -90, width: screenSize.width-20, height: 65))
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.backgroundColor = .white
        
        
        let titleLbl = UILabel()
        titleLbl.frame = view.frame
        titleLbl.textColor = .white
        titleLbl.minimumScaleFactor = 8
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.textAlignment = .center
        
        titleLbl.numberOfLines = 3
        titleLbl.font = UIFont(name: "Inter-Medium", size: 15)

        view.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        titleLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        titleLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        titleLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true

        view.tag = 9981
        
        if let window = (UIApplication.shared.delegate as! AppDelegate).window {
            if let vi = window.viewWithTag(9981) {
                timer?.invalidate()
                vi.removeFromSuperview()
            }
            window.addSubview(view)
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: 90+UIApplication.shared.statusBarFrame.size.height)
        })
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(closeBtnPressed))
        swipeLeft.direction = .up
        view.addGestureRecognizer(swipeLeft)
        
        titleLbl.text = message
        
        switch forState {
        case .warning:
            view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case .error:
            view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .success:
            view.backgroundColor = .green
        case .unknown:
            view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case .clear:
            view.backgroundColor = .clear
        }
        
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(Alert.closeBtnPressed), userInfo: nil, repeats: false)
    }
    
    @objc class func closeBtnPressed() {
        timer?.invalidate()
        if let window = (UIApplication.shared.delegate as! AppDelegate).window, let view = window.viewWithTag(9981) {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                view.transform = .identity
            }) { (_) in
                view.removeFromSuperview()
            }
        }
    }
    
    //MARK: Show Alert
    class func showAlertWithBool(forState: AlertType, message: String, duration: TimeInterval = 4, userInteration: Bool = true, isShow: Bool) {
                
        let view = UIView(frame: CGRect(x: 10, y: -90, width: screenSize.width-20, height: 65))
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        
        view.backgroundColor = .white
        
        let titleLbl = UILabel()
        titleLbl.frame = view.frame
        titleLbl.textColor = .white
        titleLbl.minimumScaleFactor = 8
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.textAlignment = .center
        
        titleLbl.numberOfLines = 3
        titleLbl.font = UIFont(name: "Inter-Medium", size: 15)

        view.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        titleLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        titleLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        titleLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true

        view.tag = 9982
        
        if let window = (UIApplication.shared.delegate as! AppDelegate).window {
            if let vi = window.viewWithTag(9982) {
                timer?.invalidate()
                vi.removeFromSuperview()
            }
            window.addSubview(view)
        }
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform(translationX: 0, y: 90+UIApplication.shared.statusBarFrame.size.height)
        })
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(closeBtnPressed1))
        swipeLeft.direction = .up
        view.addGestureRecognizer(swipeLeft)
        
        titleLbl.text = message
        
        switch forState {
        case .warning:
            view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case .error:
            view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

        case .success:
            view.backgroundColor = .green
        case .unknown:
            view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case .clear:
            view.backgroundColor = .clear
        }
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(Alert.closeBtnPressed1), userInfo: nil, repeats: false)
        if !isShow {
            if let window = (UIApplication.shared.delegate as! AppDelegate).window, let view = window.viewWithTag(9982) {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                    view.transform = .identity
                }) { (_) in
                    view.removeFromSuperview()
                }
            }
        }
        
    }
    
    @objc class func closeBtnPressed1() {
        timer?.invalidate()
        
        if let window = (UIApplication.shared.delegate as! AppDelegate).window, let view = window.viewWithTag(9982) {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                view.transform = .identity
            }) { (_) in
                view.removeFromSuperview()
            }
        }
    }
    
    
}
