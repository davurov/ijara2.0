//
//  WelcomePageVC.swift
//  ijara
//
//  Created by Abduraxmon on 24/07/23.
//

import UIKit

class WelcomePageVC: UIViewController {
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.addShadow()
            bottomView.layer.cornerRadius = 60
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var introLbl: UILabel! {
        didSet{
            introLbl.text = SetLanguage.setLang(type: .introLbl)
        }
    }
    var registerChildVC: RegisterChildVC!
    var verificationChildVC: VerificationChildVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        addChildForWelcomeVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func addChildForWelcomeVC() {
        registerChildVC = RegisterChildVC(nibName: "RegisterChildVC", bundle: nil)
        self.add(registerChildVC)
        showHomeChildNotRemove(isDraggingMap: false)
        registerChildVC.delegete = self
    }
    
    func addVerificationForWelcomeVC() {
        verificationChildVC = VerificationChildVC(nibName: "VerificationChildVC", bundle: nil)
        self.add(verificationChildVC)
        showHomeChildNotRemove(isDraggingMap: false)
        verificationChildVC.delegete = self
    }
    
    @IBAction func startPressed(_ sender: Any) {
        bottomViewHeight.constant = view.frame.height - 30
        
        UIView.animate(withDuration: 0.5) { [self] in
            bottomView.transform = CGAffineTransform(translationX: 0, y: 50)
        }
    }
    
    func showHomeChildNotRemove(isDraggingMap: Bool = false) {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) {[self] t in
            if !isDraggingMap {
                liftChild(height: registerChildVC.partial, child: registerChildVC)
            }else {
                liftChild(height: registerChildVC.partial+180, child: registerChildVC)
            }
            t.invalidate()
        }
    }
}

//MARK: - RegisterDelegete
extension WelcomePageVC: RegisterDelegete {
    func nextPressed() {
        self.removeChild()
        addVerificationForWelcomeVC()
        liftChild(height: 0, child: verificationChildVC)
    }
    
    func startPressed() {
        liftChild(height: 0, child: registerChildVC)
    }
}
//MARK: - VerificationDelegate
extension WelcomePageVC: VerificationDelegate {
    func verified() {
        //Present HomeVC
        let vc = CustomTabBar()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}
