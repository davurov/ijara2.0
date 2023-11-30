//
//  WelcomePageVC.swift
//  ijara
//
//  Created by Abduraxmon on 24/07/23.
//

import UIKit

class WelcomePageVC: UIViewController {

    @IBOutlet weak var introLbl: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func startPressed(_ sender: Any) {
        let vc = CustomTabBar()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
 
    private func setupViews(){
        navigationController?.navigationBar.isHidden = true
        
        introLbl.text = SetLanguage.setLang(type: .introLbl)
        
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.cornerRadius = 33
        bottomView.backgroundColor = AppColors.customGray
        
        startBtn.backgroundColor = AppColors.mainColor
        startBtn.setTitleColor(AppColors.customGray, for: .normal)
        startBtn.titleLabel?.textColor = AppColors.customGray
        startBtn.setTitle(SetLanguage.setLang(type: .getStartBtn), for: .normal)
        startBtn.layer.cornerRadius = 25
        startBtn.clipsToBounds = true
    }
    
}
