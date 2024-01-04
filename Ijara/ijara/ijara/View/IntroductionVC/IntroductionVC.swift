//
//  IntroductionVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 14/12/23.
//

import UIKit

class IntroductionVC: UIViewController {
    
    @IBOutlet weak var descreptionLbl: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage(currentPage)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        currentPage += 1
        setupPage(currentPage)
    }
    
    private func setupPage(_ page: Int){
        switch page {
        case 0:
            descreptionLbl.text = SetLanguage.setLang(type: .introductionForVillas)
            img.image = UIImage(named: "villaImgForBackground")
            pageController.currentPage = currentPage
            nextBtn.setTitle(SetLanguage.setLang(type: .next), for: .normal)
        case 1:
            descreptionLbl.text = SetLanguage.setLang(type: .introductionForTaxis)
            img.image = UIImage(named: "taxiImgBackground")
            pageController.currentPage = currentPage
            nextBtn.setTitle(SetLanguage.setLang(type: .next), for: .normal)
        case 2:
            descreptionLbl.text = SetLanguage.setLang(type: .introductionForChildrenParties)
            img.image = UIImage(named: "childrensPartyImgForBackgroun")
            pageController.currentPage = currentPage
            nextBtn.setTitle(SetLanguage.setLang(type: .getstartLangBtn), for: .normal)
        default:
            UserDefaults.standard.set(true, forKey: Keys.isUserEnteredFirstTime)
            let vc = CustomTabBar()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
}
