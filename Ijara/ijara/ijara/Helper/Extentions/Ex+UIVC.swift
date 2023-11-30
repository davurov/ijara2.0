//
//  Ex+UIVC.swift
//  ijara
//
//  Created by Abduraxmon on 14/08/23.
//

import Foundation
import UIKit

//MARK: Lift Child
extension UIViewController {
    func liftChild(height: CGFloat, child: UIViewController) {
        UIView.animate(withDuration: 0.2) {
            child.view.transform = CGAffineTransform(translationX: 0, y: height)
        }
    }
}

extension UIViewController {
    
    func setUpNavigation(title: String, titleFontSize: Int, barBtnColor: UIColor, largetitle: Bool) {
        
        navigationController?.navigationBar.topItem?.title = ""
        
        navigationController?.navigationBar.prefersLargeTitles = largetitle
        
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = barBtnColor
        
    }
    
    func hideBar(){
        let nav = UINavigationController()
        
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.view.backgroundColor = .clear
    }
    
    
    func backBtn(nav: UINavigationController?, name: String = "chevronLeft", tinColor: UIColor = .white) {
        
        let yourBackImage = UIImage(named: name)
        nav?.navigationBar.backIndicatorImage = yourBackImage
        nav?.navigationBar.topItem?.title = ""
        nav?.navigationBar.tintColor = tinColor
        nav?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
    var isSmallScreen : Bool {
        if UIScreen.main.bounds.height < 670 {
            return true
        }
        return false
    }
    
}

//MARK: Small screen for collection view
extension UICollectionViewCell {
    
    var isSmallScreen : Bool {
        if UIScreen.main.bounds.height < 670 {
            return true
        }
        return false
    }
    
}

//MARK: Small screen for table view
extension UITableViewCell {
    
    var isSmallScreen : Bool {
        
        if UIScreen.main.bounds.height < 670 {
            return true
        } else {
            return false
        }
        
    }
    
}


//MARK: - Alert shows

extension UIViewController{
    //System alert shows
    public func showSystemAlert(title: String?,
                                message: String?,
                                alertType: UIAlertController.Style,
                                actionTitles: [String?],
                                style: [UIAlertAction.Style],
                                actions: [((UIAlertAction) -> Void)?],
                                preferredActionIndex: Int? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertType)
        alert.view.tintColor = AppColors.mainColor
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: style[index], handler: actions[index])
            
            alert.addAction(action)
        }
        
        if let preferredActionIndex = preferredActionIndex { alert.preferredAction = alert.actions[preferredActionIndex] }
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: PanGesture
extension UIViewController {
    
    static let minimumVelocityToHide: CGFloat = 1500
    
    static let minimumScreenRatioToHide: CGFloat = 0.2
    
    static let animationDuration: TimeInterval = 0.2
    
    func slideViewVerticallyTo(_ y: CGFloat) {
        self.view.frame.origin = CGPoint(x: 0, y: y)
    }
    
    
    @objc func onPan(_ panGesture: UIPanGestureRecognizer) {
        
        switch panGesture.state {
        case .began, .changed:
            // If pan started or is ongoing then
            // slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            let y = max(0, translation.y)
            slideViewVerticallyTo(y)
            self.view.backgroundColor = .clear
            
        case .ended:
            // If pan ended, decide it we should close or reset the view
            // based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > self.view.frame.size.height * UIViewController.minimumScreenRatioToHide) ||
            (velocity.y > UIViewController.minimumVelocityToHide)
            
            if closing {
                UIView.animate(withDuration: UIViewController.animationDuration, animations: {
                    // If closing, animate to the bottom of the view
                }, completion: { (isCompleted) in
                    
                    self.dismiss(animated: true, completion: nil)
                    if isCompleted {
                        // Dismiss the view when it dissapeared
                    }
                })
            } else {
                // If not closing, reset the view to the top
                UIView.animate(withDuration: UIViewController.animationDuration, animations: {
                    self.slideViewVerticallyTo(0)
                })
            }
            
        default:
            // If gesture state is undefined, reset the view to the top
            UIView.animate(withDuration: UIViewController.animationDuration, animations: {
                self.slideViewVerticallyTo(0)
            })
            
        }
    }
    
}

//MARK: SHOW and HIDE CHILD
extension UIViewController {
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        // saving view controllerts name to defoults. not to add two exact childs
        
        child.view.frame = self.view.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.view.transform = .init(translationX: 0, y: view.frame.height)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        UIView.animate(withDuration: 12){[ self] in
            view.transform = CGAffineTransform(translationX: 0, y: screenSize.height)
            view.removeFromSuperview()
            removeFromParent()
        }
    }
    
}

//MARK: This is to remove child view controllers
extension UIViewController {
    
    func removeChild() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
}
