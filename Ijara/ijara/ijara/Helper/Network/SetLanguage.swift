//
//  SetLanguage.swift
//  ijara
//
//  Created by Abduraxmon on 14/08/23.
//

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
            ///`          Login
        case .selectLangLbl: return "Tilni tanlang"
        case .getstartLangBtn: return "Boshlash"
        case .signUpBtn: return "Ro'yxatdan o'tish"
        case .phoneVerLbl: return "Telefoningzni tasdiqlang"
        case .enterCodeLbl: return "OTP kodini shu yerga kiriting"
        case .verifyBtn: return "Tasdiqlash"
        case .getStartBtn: return "Boshlash"
        case .introLbl: return "Siz uchun ijaraga uy, dacha topamiz."
        case .searchTfPlaceholder: return "Qidirish"
        case .nearBy: return "Yaqindagi"
            
            ///`           ProfileVC
        case .profileTitle : return "Shaxsiy kabinet"
        case .showProfile  : return "Profilni ko`rish"
        case .settings     : return "Sozlamalar"
        case .about        : return "Ilova haqida"
        case .appLanguage  : return "Ilova tili"
        case .privcyPolicy : return "Maxfiylik siyosati"
        case .otherApps    : return "Boshqa ilovalar"
        case .logOut       : return "Chiqish"
            
            ///`           HomeDetailVC
        case .rules              : return "Qoidalar"
        case .additionalFeatures : return "Qo'shimcha funktsiyalar"
        case .showAllElementsBtn : return "Barcha elementlarni ko'rsatish"
        case .commentByOwner     : return "Egasining izohi"
        case .contactInfo        : return "Bog`lanish uchun kontaktlar"
        case .phoneLbl           : return "Telefon"
        case .comingTime         : return "Kelish vaqti"
        case .leavingTime        : return "Ketish vaqti"
        case .callBtn            : return "Qo'ng'iroq qilish"
            
            ///`           MapVC
        case .looking  : return "Qidirilmoqda..."
        case .moreInfo : return "Qo`shimcha ma`lumotlar"
        }
    }
}

extension SetLanguage{
    class func getRuValue(type: ClassType)-> String {
        switch type{
            ///`          Login
        case .selectLangLbl       : return "Выберите язык"
        case .getstartLangBtn     : return "Начать"
        case .signUpBtn           : return "Регистрация"
        case .phoneVerLbl         : return "Проверка телефона"
        case .enterCodeLbl        : return "Введите OTP-код здесь"
        case .verifyBtn           : return "Проверять"
        case .getStartBtn         : return "Начать"
        case .introLbl            : return "Мы подберем для вас дом в аренду"
        case .searchTfPlaceholder : return "Ищите сейчас"
        case .nearBy              : return "Рядом"
            
            ///`           ProfileVC
        case .profileTitle : return "Профиль"
        case .showProfile  : return "Показать профиль"
        case .settings     : return "Настройки"
        case .about        : return "О нас"
        case .appLanguage  : return "Язык приложения"
        case .privcyPolicy : return "Политика конфиденциальности"
        case .otherApps    : return "Другие приложения"
        case .logOut       : return "Выйти"

            ///`           HomeDetailVC
        case .rules              : return "Правила"
        case .additionalFeatures : return "Дополнительные возможности"
        case .showAllElementsBtn : return "Показать все элементы"
        case .commentByOwner     : return "Комментарий владельца"
        case .contactInfo        : return "Контактная информация"
        case .phoneLbl           : return "Телефон"
        case .comingTime         : return "Время прихода"
        case .leavingTime        : return "Время ухода"
        case .callBtn            : return "Вызов"
            
            ///`           MapVC
        case .looking  : return "Поиск..."
        case .moreInfo : return "Дополнительная информация"
        }
    }
}

extension SetLanguage{
    class func getEnValue(type: ClassType)-> String {
        switch type{
            ///`          Login
        case .selectLangLbl       : return "Choose language"
        case .getstartLangBtn     : return "Get started"
        case .signUpBtn           : return "Sign Up"
        case .phoneVerLbl         : return "Phone verification"
        case .enterCodeLbl        : return "Enter OTP code here"
        case .verifyBtn           : return "Verify now"
        case .getStartBtn         : return "Start"
        case .introLbl            : return "We will find a house for rent for you"
        case .searchTfPlaceholder : return "Search now"
        case .nearBy              : return "Near by"
            
            ///`          ProfileVC
        case .profileTitle: return "Profile"
        case .showProfile : return "Show profile"
        case .settings    : return "Settings"
        case .about       : return "About"
        case .appLanguage : return "App language"
        case .privcyPolicy: return "Privcy policy"
        case .otherApps   : return "Other app"
        case .logOut      : return "Log out"
            
            ///`           HomeDetailVC
        case .rules              : return "Rules"
        case .additionalFeatures : return "Additional features"
        case .showAllElementsBtn : return "Show all elements"
        case .commentByOwner     : return "Comment by owner"
        case .contactInfo        : return "Contact info"
        case .phoneLbl           : return "Phone"
        case .comingTime         : return "Coming time"
        case .leavingTime        : return "Leaving time"
        case .callBtn            : return "Call"
            
            ///`           MapVC
        case .looking  : return "Lookin..."
        case .moreInfo : return "More info"
        }
    }
}

enum ClassType {
    //LanguageVC
    case selectLangLbl
    case getstartLangBtn
    //RegisterChildVC
    case getStartBtn
    //SignUpVC=
    case signUpBtn
    //VerifyVC
    case phoneVerLbl
    case enterCodeLbl
    case verifyBtn
    //WelcomeVC
    case introLbl
    //HomeVC
    case searchTfPlaceholder
    case nearBy
    //ProfileVC
    case profileTitle
    case showProfile
    case settings
    case about
    case appLanguage
    case privcyPolicy
    case otherApps
    case logOut
    //HomeDetailVC
    case rules
    case additionalFeatures
    case showAllElementsBtn
    case commentByOwner
    case contactInfo
    case phoneLbl
    case comingTime
    case leavingTime
    case callBtn
    //MapVC
    case looking, moreInfo
}
