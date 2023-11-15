//
//  ProfileVC.swift
//  ijara
//
//  Created by Abduraxmon on 15/09/23.
//

import UIKit
import FirebaseAuth

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
    @IBOutlet weak var logOutLbl: UILabel!
    
    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear in profile")
        userImage.image = UIImage().loadImage() ?? UIImage(systemName: "person.fill")
        let info = UserDefaults.standard.array(forKey: Keys.userInfo) as? [String]
        nameLbl.text = info?[1] ?? "User"
    }
    
    //MARK: @IBAction functions
    @IBAction func profilePressed(_ sender: Any) {
        let vc = EditProfileVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func aboutPressed(_ sender: Any) {
        guard let botURL = URL.init(string: "https://bronla.uz/about") else { return }
        UIApplication.shared.open(botURL)
    }
    
    @IBAction func appLanguagePressed(_ sender: Any) {
        let english : ((UIAlertAction) -> Void) = { (action) in
            UserDefaults.standard.setValue("en", forKey: Keys.LANG)
            self.reloadApp()
        }
        
        let uzbek : ((UIAlertAction) -> Void) = { (action) in
            UserDefaults.standard.setValue("uz", forKey: Keys.LANG)
            self.reloadApp()
        }
        let russian : ((UIAlertAction) -> Void) = { (action) in
            UserDefaults.standard.setValue("ru", forKey: Keys.LANG)
            self.reloadApp()
        }
        
        showSystemAlert(title: SetLanguage.setLang(type: .chooseLanguage), message: nil, alertType: .actionSheet, actionTitles: ["English", "Русский","O`zbekcha", SetLanguage.setLang(type: .cancelTitle)], style: [.default, .default, .default, .cancel], actions: [english,russian,uzbek,nil])
    }
    
    @IBAction func privacyPolice(_ sender: Any) {
        guard let botURL = URL.init(string: "https://bronla.uz/privacy-policy") else { return }
        UIApplication.shared.open(botURL)
    }
    
    @IBAction func otherApps(_ sender: Any) {
        guard let botURL = URL.init(string: "https://apps.apple.com/us/developer/uchqun-tulavov") else { return }
        UIApplication.shared.open(botURL)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        showAlertDelete()
    }
    
    //MARK: functions
    func showAlertDelete() {
        let vc = UIAlertController(title: SetLanguage.setLang(type: .deleteAccaunt), message: SetLanguage.setLang(type: .deleteAccauntWarningMessage), preferredStyle: .alert)
        
        let ok = UIAlertAction(title: SetLanguage.setLang(type: .yes), style: .destructive) { _ in
            let vc = SingInLangVC(nibName: "SingInLangVC", bundle: nil)
            let nav = UINavigationController(rootViewController: vc)
            UserDefaults.standard.set(nil, forKey: Keys.token)
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = nav
        }
        
        let no = UIAlertAction(title: SetLanguage.setLang(type: .no), style: .default)
        
        vc.addAction(no)
        vc.addAction(ok)
        
        present(vc, animated: true)
        
    }
    
    private func setupViews(){
        profileTitle.text     = SetLanguage.setLang(type: .profileTitle)
        showProfileLbl.text   = SetLanguage.setLang(type: .showProfile)
        settingsLbl.text      = SetLanguage.setLang(type: .settings)
        aboutLbl.text         = SetLanguage.setLang(type: .about)
        appLanguageLbl.text   = SetLanguage.setLang(type: .appLanguage)
        privacyPolicyLbl.text = SetLanguage.setLang(type: .privcyPolicy)
        OtherAppsLbl.text     = SetLanguage.setLang(type: .otherApps)
        logOutLbl.text        = SetLanguage.setLang(type: .logOut)
    }
    
    private func reloadApp(){
        setupViews()
        Loader.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Loader.stop()
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = CustomTabBar()
        }
    }
    
}
