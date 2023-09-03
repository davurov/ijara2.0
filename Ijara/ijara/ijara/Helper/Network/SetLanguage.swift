//
//  SetLanguage.swift
//  ijara
//
//  Created by Abduraxmon on 14/08/23.
//

import Foundation

class SetLanguage {
    
    class func setLang(type: ClassType )-> String {
        let lang = UserDefaults.standard.string(forKey: Keys.LANG)
        if lang == "uz" {
            return SetLanguage.getUzValue(type: type)
        }else if lang == "ru" {
            return SetLanguage.getRuValue(type: type)
        } else {
            return SetLanguage.getEnValue(type: type)
        }
    }
}

extension SetLanguage{
    class func getUzValue(type: ClassType)-> String {
        switch type{
        case .selectLangLbl: return "Tilni tanlang"
        case .getstartLangBtn: return "Boshlash"
        case .signUpBtn: return "Ro'yxatdan o'tish"
        case .phoneVerLbl: return "Telefoningzni tasdiqlang"
        case .enterCodeLbl: return "OTP kodini shu yerga kiriting"
        case .verifyBtn: return "Tasdiqlash"
        case .getStartBtn: return "Boshlash"
        case .introLbl: return "Siz uchun ijaraga uy, dacha topamiz."
        }
    }
}

extension SetLanguage{
    
    class func getRuValue(type: ClassType)-> String {
        switch type{
        case .selectLangLbl: return "Выберите язык"
        case .getstartLangBtn: return "Начать"
        case .signUpBtn: return "Регистрация"
        case .phoneVerLbl: return "Проверка телефона"
        case .enterCodeLbl: return "Введите OTP-код здесь"
        case .verifyBtn: return "Проверять"
        case .getStartBtn: return "Начать"
        case .introLbl: return "Мы подберем для вас дом в аренду"
        }
    }
}

extension SetLanguage{
    class func getEnValue(type: ClassType)-> String {
        switch type{
        case .selectLangLbl: return "Choose language"
        case .getstartLangBtn:  return "Get started"
        case .signUpBtn: return "Sign Up"
        case .phoneVerLbl: return "Phone verification"
        case .enterCodeLbl: return "Enter OTP code here"
        case .verifyBtn: return "Verify now"
        case .getStartBtn: return "Start"
        case .introLbl: return "We will find a house for rent for you"
        }
    }
}


enum ClassType {
    //LanguageVC
    case selectLangLbl
    case getstartLangBtn
    case getStartBtn
    //SignUpVC
    case signUpBtn
    //VerifyVC
    case phoneVerLbl
    case enterCodeLbl
    case verifyBtn
    //WelcomeVC
    case introLbl

}
