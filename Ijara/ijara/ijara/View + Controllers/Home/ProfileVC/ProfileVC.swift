//
//  ProfileVC.swift
//  ijara
//
//  Created by Abduraxmon on 15/09/23.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        userImage.image = UIImage().loadImage() ?? UIImage(systemName: "person.fill")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let info = UserDefaults.standard.array(forKey: Keys.userInfo) as? [String]
        nameLbl.text = info?.last ?? "User"
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        let vc = EditProfileVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func aboutPressed(_ sender: Any) {
        guard let botURL = URL.init(string: "https://bronla.uz/about") else { return }
        UIApplication.shared.open(botURL)
    }
    
    @IBAction func appLanguagePressed(_ sender: Any) {
        let english : ((UIAlertAction) -> Void) = { (action) in
            UserDefaults.standard.setValue("en", forKey: Keys.LANG)
        }
        
        let uzbek : ((UIAlertAction) -> Void) = { (action) in
            UserDefaults.standard.setValue("uz", forKey: Keys.LANG)
        }
        let russian : ((UIAlertAction) -> Void) = { (action) in
            UserDefaults.standard.setValue("ru", forKey: Keys.LANG)
        }
        
        showSystemAlert(title: "Choose Language", message: nil, alertType: .actionSheet, actionTitles: ["English", "Russian","Uzbek","Cancel"], style: [.default, .default, .default, .cancel], actions: [english,russian,uzbek,nil])
        
        
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
    
    func showAlertDelete() {
        let vc = UIAlertController(title: "Delete accaunt", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Yes", style: .destructive) { _ in
            let vc = SingInLangVC(nibName: "SingInLangVC", bundle: nil)
            let nav = UINavigationController(rootViewController: vc)
            UserDefaults.standard.set(nil, forKey: Keys.token)
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = nav
        }
        
        let no = UIAlertAction(title: "No", style: .default)
        
        vc.addAction(no)
        vc.addAction(ok)
        
        present(vc, animated: true)
        
    }
}
