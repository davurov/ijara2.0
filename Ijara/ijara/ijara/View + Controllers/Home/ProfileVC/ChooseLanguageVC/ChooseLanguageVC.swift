//
//  ChooseLanguageVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 26/11/23.
//

import UIKit

class ChooseLanguageVC: UIViewController {
    
    @IBOutlet weak var miniView: UIView!
    
    @IBOutlet weak var dismissView: UIView!
    
    @IBOutlet weak var chooseLangLbl: UILabel!
    
    @IBOutlet weak var uzView: UIView!
    
    @IBOutlet weak var ruView: UIView!
    
    @IBOutlet weak var engView: UIView!
    
    @IBOutlet weak var uzCheckmark: UIImageView!
    
    @IBOutlet weak var ruCheckmark: UIImageView!
    
    @IBOutlet weak var engCheckmark: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        clearAllOptions()
        findCurrentLanguage()
    }
    
    //MARK: @objc functions
    
    @IBAction func uzPressed(_ sender: Any) {
        clearAllOptions()
        
        uzView.backgroundColor = .systemGray2
        uzCheckmark.isHidden = false
        
        UserDefaults.standard.setValue("uz", forKey: Keys.LANG)
        reloadApp()
    }
    
    @IBAction func ruPressed(_ sender: Any) {
        clearAllOptions()
        
        ruView.backgroundColor = .systemGray2
        ruCheckmark.isHidden = false
        
        UserDefaults.standard.setValue("ru", forKey: Keys.LANG)
        reloadApp()
    }
    
    @IBAction func engPressed(_ sender: Any) {
        clearAllOptions()
        
        engView.backgroundColor = .systemGray2
        engCheckmark.isHidden = false
        
        UserDefaults.standard.setValue("en", forKey: Keys.LANG)
        reloadApp()
    }
    
    @IBAction func dismissAreaPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @objc func dismissView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            dismiss(animated: true)
        }
    }
    
    //MARK: functions
    
    private func clearAllOptions(){
        uzView.backgroundColor = .systemGray6
        ruView.backgroundColor = .systemGray6
        engView.backgroundColor = .systemGray6
        
        uzCheckmark.isHidden = true
        ruCheckmark.isHidden = true
        engCheckmark.isHidden = true
    }
    
    private func findCurrentLanguage() {
        switch UserDefaults.standard.string(forKey: Keys.LANG) {
        case "uz":
            uzView.backgroundColor = .systemGray2
            uzCheckmark.isHidden = false
        case "ru":
            ruView.backgroundColor = .systemGray2
            ruCheckmark.isHidden = false
        default:
            engView.backgroundColor = .systemGray2
            engCheckmark.isHidden = false
        }
    }
    
    private func reloadApp(){
        setupViews()
        Loader.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Loader.stop()
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = CustomTabBar()
        }
    }
    
    private func setupViews(){
        //view
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)
        let dismissGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        dismissGesture.direction = .down
        view.addGestureRecognizer(dismissGesture)
        view.isUserInteractionEnabled = true
        
        //miniView
//        miniView.addBorder(size: 3)
        miniView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        miniView.layer.cornerRadius = 50
        miniView.clipsToBounds = true
        
        //dismissView
        dismissView.layer.cornerRadius = 3
        dismissView.clipsToBounds = true
        
        //chooseLangLbl
        chooseLangLbl.text = SetLanguage.setLang(type: .chooseLanguage)
        
        //uzView
        uzView.layer.cornerRadius = 15
        uzView.clipsToBounds = true
        
        
        //ruView
        ruView.layer.cornerRadius = 15
        ruView.clipsToBounds = true
        
        //engView
        engView.layer.cornerRadius = 15
        engView.clipsToBounds = true
    }
    
}
