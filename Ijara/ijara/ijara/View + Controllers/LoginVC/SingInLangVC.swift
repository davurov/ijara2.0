
//  SingInLangVC.swift
//  Taxi
//  Created by Abdulloh Abdulhamid on 18/04/22.

import UIKit

class SingInLangVC: UIViewController {
    
    @IBOutlet weak var chooseLangLbl: UILabel!{
        didSet{
            chooseLangLbl.text = SetLanguage.setLang(type: .selectLangLbl)
        }
    }
    
    @IBOutlet weak var getStartBtn: UIButton!{
        didSet{
            getStartBtn.setTitle(SetLanguage.setLang(type: .getStartBtn), for: .normal)
            getStartBtn.backgroundColor = AppColors.mainColor
        }
    }
    
    @IBOutlet weak var QozoqLbl: UIButton!
    
    
    @IBOutlet weak var headerView: UIImageView! {
        didSet {
            headerView.backgroundColor = AppColors.mainColor
        }
    }
    
    @IBOutlet weak var popView: UIView!{
        didSet{
            popView.clipsToBounds = true
            popView.layer.cornerRadius = 8
            popView.layer.shadowColor =  AppColors.customBlack.cgColor
            popView.layer.shadowRadius = 3
            popView.layer.shadowOpacity = 0.1
        }
    }
    @IBOutlet var langBtnConViews: [UIView]!{
        didSet {
            changedBorderToWhite()
        }
    }
    var isSelectLang: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        

        switch UserDefaults.standard.string(forKey: Keys.LANG){
        case "uz":
            langBtnConViews[0].layer.borderColor = AppColors.mainColor.cgColor
            isSelectLang = true
        case "ru":
            langBtnConViews[1].layer.borderColor = AppColors.mainColor.cgColor
            isSelectLang = true
        case "kz":
            langBtnConViews[3].layer.borderColor = AppColors.mainColor.cgColor
            isSelectLang = true
        default:
            langBtnConViews[2].layer.borderColor = AppColors.mainColor.cgColor
            isSelectLang = true
        }
        
        
        QozoqLbl.setTitle("\(flag(country: "KZ")) Қазақ", for: .normal)
    }
    
    func changedBorderToWhite() {
        for i in langBtnConViews {
            i.addShadow()
            i.layer.borderWidth = 1
            i.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }

    @IBAction func langBtnsPressed(_ sender: UIButton){
        changedBorderToWhite()
        langBtnConViews[sender.tag].layer.borderColor = AppColors.mainColor.cgColor
        if sender.tag == 0 {
            UserDefaults.standard.set("uz", forKey: Keys.LANG)
        } else if sender.tag == 1{
            UserDefaults.standard.set("ru", forKey: Keys.LANG)
        } else if sender.tag == 2 {
            UserDefaults.standard.set("en", forKey: Keys.LANG)
        } else {
            UserDefaults.standard.set("kz", forKey: Keys.LANG)
        }
        isSelectLang = true
        chooseLangLbl.text = SetLanguage.setLang(type: .selectLangLbl)
        getStartBtn.setTitle(SetLanguage.setLang(type: .getStartBtn), for: .normal)
    }
   
    @IBAction func goToSignUpBtnPressed(_ sender: UIButton) {

        if isSelectLang {
            let vc = WelcomePageVC(nibName: "WelcomePageVC", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            switch UserDefaults.standard.string(forKey: Keys.LANG){
            case "uz":
                Alert.showAlert(forState: .warning, message: "Iltimos tilni tanlang")
            case "ru":
                Alert.showAlert(forState: .warning, message: "Пожалуйста, выберите ваш язык")
            default:
                Alert.showAlert(forState: .warning, message: "Please select your language")
            }
        }
    }
    
}

