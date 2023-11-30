//
//  ProfileVC.swift
//  ijara
//
//  Created by Abduraxmon on 15/09/23.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: Elements
    
    @IBOutlet weak var profileTitle: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var showProfileLbl: UILabel!
    
    @IBOutlet weak var settingsLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var appLanguageLbl: UILabel!
    @IBOutlet weak var privacyPolicyLbl: UILabel!
    @IBOutlet weak var OtherAppsLbl: UILabel!
    
    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = SetLanguage.setLang(type: .profileTitle)
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userImage.image = UIImage().loadImage() ?? UIImage(systemName: "person.fill")
        
        let userInfos = UserDefaults.standard
        nameLbl.text = userInfos.string(forKey: Keys.userName) ?? SetLanguage.setLang(type: .user)
    }
    
    //MARK: @IBAction functions
    @IBAction func profilePressed(_ sender: Any) {
        navigationItem.backButtonTitle = SetLanguage.setLang(type: .profileForBackBtn)
        navigationItem.backBarButtonItem?.tintColor = AppColors.mainColor
        let vc = EditProfileVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func aboutPressed(_ sender: Any) {
        let vc = AboutAppVC()
        vc.infos = StaticDatas.aboutsUs
        vc.title = SetLanguage.setLang(type: .about)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func appLanguagePressed(_ sender: Any) {
        let vc = ChooseLanguageVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func privacyPolice(_ sender: Any) {
        let vc = AboutAppVC()
        vc.infos = StaticDatas.privcyPolicy
        vc.title = SetLanguage.setLang(type: .privcyPolicy)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func otherApps(_ sender: Any) {
        let vc = OtherAppsVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: functions
    
    private func setupViews(){
        profileTitle.text     = SetLanguage.setLang(type: .profileTitle)
        showProfileLbl.text   = SetLanguage.setLang(type: .showProfile)
        settingsLbl.text      = SetLanguage.setLang(type: .settings)
        aboutLbl.text         = SetLanguage.setLang(type: .about)
        appLanguageLbl.text   = SetLanguage.setLang(type: .appLanguage)
        privacyPolicyLbl.text = SetLanguage.setLang(type: .privcyPolicy)
        OtherAppsLbl.text     = SetLanguage.setLang(type: .otherApps)
    }
    
}
