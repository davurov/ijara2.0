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
        } else if lang == "ru" {
            return SetLanguage.getRuValue(type: type)
        } else {
            return SetLanguage.getEnValue(type: type)
        }
    }
}

extension SetLanguage{
    class private func getUzValue(type: ClassType)-> String {
        switch type{
            ///`          Login
        case .selectLangLbl:       return "Tilni tanlang"
        case .getstartLangBtn:     return "Boshlash"
        case .signUpBtn:           return "Ro'yxatdan o'tish"
        case .phoneVerLbl:         return "Telefoningzni tasdiqlang"
        case .enterCodeLbl:        return "OTP kodini shu yerga kiriting"
        case .verifyBtn:           return "Tasdiqlash"
        case .getStartBtn:         return "Boshlash"
        case .introLbl:            return "Siz uchun ijaraga uy, dacha topamiz."
            
            ///`        HouseVC
        case .searchTfPlaceholder : return "Qidirish"
        case .map                 : return "Xarita"
        case .news                : return "Yangiliklar"
        case .contacts            : return "Kontaktlar"
        case .allCategory         : return "Hammasi"
            
            ///`        HomeDetailVC
        case .priceLbl                : return "Narx"
        case .depositLbl              : return "Depozit"
        case .sumLbl                  : return "So`m"
        case .callBtn                 : return "Qo`ng`iroq"
        case .viewsLbl                : return "Ko'rildi"
        case .hostedByLbl             : return "Mezbon"
        case .peopleLbl               : return "odamlar"
        case .bedroomsLbl             : return "yotoq xonalari"
        case .bedsLbl                 : return "yotoqlar"
        case .rules                   : return "Qoidalar"
        case .additionalFeatures      : return "Qo'shimcha funktsiyalar"
        case .showAllElementsBtn      : return "Barcha elementlarni ko'rsatish"
        case .additionaFeaturesOffers : return "Bu joy nimani taklif qiladi"
        case .commentByOwner          : return "Egasining izohi"
        case .contactInfo             : return "Bog`lanish uchun kontaktlar"
        case .phoneLbl                : return "Telefon"
        case .comingTime              : return "Kelish vaqti"
        case .leavingTime             : return "Ketish vaqti"
        case .readMoreBtn             : return "Batafsil"
        case .readLess                : return "Kamroq o`qish"
        case .locationLbl             : return "Manzil"
        case .chooseDayOfVacationLbl  : return "Ta'til kunini tanlang"
        case .fridayAndSaturday       : return "Juma va shanba:"
        case .otherDays               : return "Boshqa kunlar:"
        case .numberOfPeople          : return "Odamlar soni"
        case .openLocation            : return "Manzilni ochish"
        case .openLocationMessage     : return "Yo'nalishni ochish uchun dasturni tanlang"
            
            ///`        LikedHousesVC
        case .wishlists           : return "Istaklar ro'yxati"
        case .wishlistsForBackBtn : return "Ro`yxat"
        case .delete              : return "O'chirish"
            
            ///`        Tabbar
        case .menu:  return "Menu"
        case .liked: return "Yoqqan dachalar"
            
            ///`           ProfileVC
        case .profileTitle                : return "Shaxsiy kabinet"
        case .profileForBackBtn           : return "Kabinet"
        case .user                        : return "Foydalanuvchini ismi"
        case .showProfile                 : return "Profilni ko`rish"
        case .emptyTfError                : return "Iltimos, barcha maydonlarni to'ldiring"
        case .saveBtn                     : return "Saqlash"
        case .settings                    : return "Sozlamalar"
        case .about                       : return "Ilova haqida"
        case .appLanguage                 : return "Ilova tili"
        case .chooseLanguage              : return "Tilni tanlang"
        case .cancelTitle                 : return "Bekor qilish"
        case .privcyPolicy                : return "Maxfiylik siyosati"
        case .otherApps                   : return "Boshqa ilovalar"
        case .logOut                      : return "Chiqish"
        case .deleteAccaunt               : return "Akkountni o`chirish"
        case .deleteAccauntWarningMessage : return "Akkauntingizni o'chirishni xohlayotganingizga aminmisiz ?"
        case .no                          : return "Yo`q"
        case .yes                         : return "Ha"
        case .firstNameTF                 : return "Ism"
        case .lastNameTF                  : return "Familiya"
            
            ///`           MapVC
        case .looking  : return "Qidirilmoqda..."
        case .moreInfo : return "Qo`shimcha ma`lumotlar"
            
            ///`        FilterVC
        case .priceRange: return "Narxlar oralig'i"
        case .minimum   : return "Minimal"
        case .maximum   : return "Maksimal"
        case .guestType : return "Mehmon turi"
        case .famely    : return "Oila"
        case .female    : return "Ayol"
        case .male      : return "Erkak"
        case .mix       : return "Aralash"
        case .additional: return "Qo'shimcha"
        case .alcohol   : return "Spirtli ichimliklar"
        case .verified  : return "Tasdiqlangan"
        case .clearAll  : return "Hammasini tozalash"
        case .show      : return "Ko'rsatish"
            
            ///`           ContactVC
        case .contactUs           : return "Biz bilan bog'laning"
        case .mainPage            : return "Asosiy sahifa"
        case .companyAdress       : return "O'zbekiston, Toshkent"
        case .companyAdressDetail : return "Muxtor Ashrafiy Ko'chasi, 51"
        case .workingTimeForCall  : return "Dushanbadan shanbagacha 9:00 dan 18:00 gacha"
        case .sendAnyTime         : return "Bizga istalgan vaqtda so'rov yuboring"
        case .enterNameTF         : return "Ismingizni kiriting"
        case .enterEmailTF        : return "Elektron pochtangizni kiriting"
        case .enterThemTF         : return "Mavzularni kiriting"
        case .enterMessageTF      : return "Xabarni kiriting"
        case .sendMessage         : return "Xabar yuborish"
        case .doneToolButton      : return "Bajarildi"
        case .homeForBackButton   : return "Bosh sahifa"
        case .successfullySend    : return "Xabar muvaffaqiyatli yuborildi"
        case .emptyField          : return "Maydon bo`sh"
            
            ///`           ContactVC
        case .taxi               : return "Taksi"
        case .taxiType           : return "Taksi turi"
        case .numberOfPassangers : return "Yo`lo`vchilar"
        case .minimumConditions  : return "Minimal shartlar"
        case .recommendedCars    : return "Tavsiya etilganlar"
        case .cheaperCars        : return "Arzonroq"
        case .expensiveCars      : return "Qimmatroq"
            
            ///`           ChildrensServiceVC
        case .childrens      : return "Bolalar"
        case .childrenEvents : return "Bolalar tadbirlari"
        case .images         : return "rasmlar"
            
            ///`           Intdoduction
        case .introductionForVillas          :  return "Orzu qilgan ta'tillaringizni haqiqatga aylantiramiz. O`zingizga yoqqan dachani bron qiling."
        case .introductionForTaxis           :  return "Tirbandliklarmi? Navbatlarmi? Unuting! Bizning taxi xizmatimizdan foydalaning"
        case .introductionForChildrenParties :  return "Noyob bayramni tashkil qiling! Biz sizning farzandingiz uchun maxsus tadbirlarni yaratishda yordam beramiz"
        case .next                           :  return "Keyingisi"
            
            // additional
        case .all                   : return "Barchasi"
        case .contactAndComment : return "Izoh & Kontakt"
        case .houses                : return "Dachalar"
        case .openYandexMap         : return "Yadex kartani ochish"
        case .noInternetMessage     : return "Internetga ulanmagan"

        }
    }
}

extension SetLanguage{
    class private func getRuValue(type: ClassType)-> String {
        switch type {
            ///`          Login
        case .selectLangLbl       : return "Выберите язык"
        case .getstartLangBtn     : return "Начать"
        case .signUpBtn           : return "Регистрация"
        case .phoneVerLbl         : return "Проверка телефона"
        case .enterCodeLbl        : return "Введите OTP-код здесь"
        case .verifyBtn           : return "Проверять"
        case .getStartBtn         : return "Начать"
        case .introLbl            : return "Мы подберем для вас дом в аренду"
            
            ///`        HouseVC
        case .searchTfPlaceholder : return "Ищите сейчас"
        case .map                 : return "Карта"
        case .news                : return "Новости"
        case .contacts            : return "Контакты"
        case .allCategory         : return "Все"
            
            ///`        HomeDetailVC
        case .priceLbl                : return "Цена"
        case .depositLbl              : return "Депозит"
        case .sumLbl                  : return "Сум"
        case .callBtn                 : return "Вызов"
        case .viewsLbl                : return "Просмотры"
        case .hostedByLbl             : return "Владелец"
        case .peopleLbl               : return "люди"
        case .bedroomsLbl             : return "спальни"
        case .bedsLbl                 : return "кровати"
        case .readMoreBtn             : return "Читать далее"
        case .readLess                : return "Читать меньше"
        case .rules                   : return "Правила"
        case .additionalFeatures      : return "Дополнительные возможности"
        case .showAllElementsBtn      : return "Показать все элементы"
        case .additionaFeaturesOffers : return "Что предлагает это место"
        case .commentByOwner          : return "Комментарий владельца"
        case .contactInfo             : return "Контактная информация"
        case .phoneLbl                : return "Телефон"
        case .comingTime              : return "Время прихода"
        case .leavingTime             : return "Время ухода"
        case .locationLbl             : return "Местоположение"
        case .chooseDayOfVacationLbl  : return "Выберите день отпуска"
        case .fridayAndSaturday       : return "Пятница и суббота:"
        case .otherDays               : return "Другие дни:"
        case .numberOfPeople          : return "Количество людей"
        case .openLocation            : return "Открыть адрес"
        case .openLocationMessage     : return "Выберите приложение, чтобы открыть направление"
        
            
            ///`        LikedHousesVC
        case .wishlists           : return "Список желаний"
        case .wishlistsForBackBtn : return "Список"
        case .delete              : return "Удалить"
            
            ///`        Tabbar
        case .menu:  return "Меню"
        case .liked: return "Понравившиеся"
            
            ///`           ProfileVC
        case .profileTitle                : return "Профиль"
        case .profileForBackBtn           : return "Профиль"
        case .user                        : return "Имя пользователя"
        case .showProfile                 : return "Показать профиль"
        case .emptyTfError                : return "Пожалуйста, заполните все поля"
        case .saveBtn                     : return "Сохранить"
        case .settings                    : return "Настройки"
        case .about                       : return "О нас"
        case .appLanguage                 : return "Язык приложения"
        case .chooseLanguage              : return "Выберите язык"
        case .cancelTitle                 : return "Отменить"
        case .privcyPolicy                : return "Политика конфиденциальности"
        case .otherApps                   : return "Другие приложения"
        case .logOut                      : return "Выйти"
        case .deleteAccaunt               : return "Удалить учетную запись"
        case .deleteAccauntWarningMessage : return "Вы уверены, что хотите удалить свою учетную запись?"
        case .no                          : return "Нет"
        case .yes                         : return "Да"
        case .firstNameTF                 : return "Имя"
        case .lastNameTF                  : return "Фамилия"
            
            ///`           MapVC
        case .looking  : return "Поиск..."
        case .moreInfo : return "Дополнительная информация"
            
            ///`        FilterVC
        case .priceRange: return "Ценовой диапазон"
        case .minimum   : return "Минимальный"
        case .maximum   : return "Максимальный"
        case .guestType : return "Гостевой тип"
        case .famely    : return "Для семейных"
        case .female    : return "Для женщин"
        case .male      : return "Для мужчин"
        case .mix       : return "Смешанный"
        case .additional: return "Дополнительный"
        case .alcohol   : return "Алкоголь"
        case .verified  : return "Проверенный"
        case .clearAll  : return "Очистить все"
        case .show      : return "Показать"
            
            ///`           ContactVC
        case .contactUs           : return "Свяжитесь с нами"
        case .mainPage            : return "Главная страница"
        case .companyAdress       : return "Узбекистан, Ташкент"
        case .companyAdressDetail : return "Улица Мухтара Ашрафи, 51"
        case .workingTimeForCall  : return "С понедельника по субботу с 9:00 до 18:00"
        case .sendAnyTime         : return "Присылайте нам запрос в любое время"
        case .enterNameTF         : return "Введите свое имя"
        case .enterEmailTF        : return "Введите свой адрес электронной почты"
        case .enterThemTF         : return "Введите тему"
        case .enterMessageTF      : return "Введите сообщение"
        case .sendMessage         : return "Отправить сообщение"
        case .doneToolButton      : return "Cделано"
        case .homeForBackButton   : return "Домой"
        case .successfullySend    : return "Сообщение успешно отправлено"
        case .emptyField          : return "Пустое поле"
            
            ///`           ContactVC
        case .taxi               : return "Такси"
        case .taxiType           : return "Тип такси"
        case .numberOfPassangers : return "Пассажиры"
        case .minimumConditions  : return "Минимальные условия"
        case .recommendedCars    : return "Рекомендуемые"
        case .cheaperCars        : return "Низкая цена"
        case .expensiveCars      : return "Высокая цена"
            
            ///`           ChildrensServiceVC
        case .childrens      : return "Дети"
        case .childrenEvents : return "Детские мероприятия"
        case .images         : return "изображения"
            
            ///`           Intdoduction
        case .introductionForVillas          :  return "Бронируйте свой отдых без забот. Мы позаботимся о деталях, вы насладитесь волшебством"
        case .introductionForTaxis           :  return "Пробки? Очереди? Забудьте! Ваш такси всего в одном касании"
        case .introductionForChildrenParties :  return "Забудьте о скучных днях рождения! Организуйте эпические праздники, которые ваши дети никогда не забудут."
        case .next                           :  return "Следующий"
            
            // additional
        case .all                   : return "Все"
        case .contactAndComment     : return "Коммент & контакт"
        case .houses                : return "Дачи"
        case .openYandexMap         : return "Открыть Яндекс-карту"
        case .noInternetMessage     : return "Не подключен к Интернету"

        }
    }
}

extension SetLanguage{
    class private func getEnValue(type: ClassType)-> String {
        switch type{
            ///`          Login
        case .selectLangLbl       : return "Choose language"
        case .getstartLangBtn     : return "Get started"
        case .signUpBtn           : return "Sign Up"
        case .phoneVerLbl         : return "Phone verification"
        case .enterCodeLbl        : return "Enter OTP code here"
        case .verifyBtn           : return "Verify now"
        case .getStartBtn         : return "Start"
        case .introLbl            : return "We will find a house for renting for you"
            
            ///`        HouseVC
        case .searchTfPlaceholder : return "Search now"
        case .map                 : return "Map"
        case .news                : return "News"
        case .contacts            : return "Contacts"
        case .allCategory         : return "All"
            
            ///`        HomeDetailVC
        case .priceLbl                : return "Price"
        case .depositLbl              : return "Deposit"
        case .sumLbl                  : return "Sum"
        case .callBtn                 : return "Call"
        case .viewsLbl                : return "Views"
        case .hostedByLbl             : return "Owner"
        case .peopleLbl               : return "people"
        case .bedroomsLbl             : return "bedrooms"
        case .bedsLbl                 : return "beds"
        case .rules                   : return "Rules"
        case .additionalFeatures      : return "Additional features"
        case .additionaFeaturesOffers : return "What this place offers"
        case .showAllElementsBtn      : return "Show all elements"
        case .commentByOwner          : return "Comment by owner"
        case .contactInfo             : return "Contact info"
        case .phoneLbl                : return "Phone"
        case .comingTime              : return "Coming time"
        case .leavingTime             : return "Leaving time"
        case .readMoreBtn             : return "Read more"
        case .readLess                : return "Read less"
        case .locationLbl             : return "Location"
        case .chooseDayOfVacationLbl  : return "Choose day of vacation"
        case .fridayAndSaturday       : return "Friday and Saturday:"
        case .otherDays               : return "Other days:"
        case .numberOfPeople          : return "Number of people"
        case .openLocation            : return "Open location"
        case .openLocationMessage     : return "Choose an app to open direction"
            
            ///`        LikedHousesVC
        case .wishlists           : return "Wishlists"
        case .wishlistsForBackBtn : return "List"
        case .delete              : return "Delete"
            
            ///`        Tabbar
        case .menu               :  return "Menu"
        case .liked              : return "Liked"
            
            ///`          ProfileVC
        case .profileTitle                : return "Profile"
        case .profileForBackBtn           : return "Profile"
        case .user                        : return "Name of user"
        case .showProfile                 : return "Show profile"
        case .emptyTfError                : return "Please complete all fields"
        case .saveBtn                     : return "Save"
        case .settings                    : return "Settings"
        case .about                       : return "About"
        case .appLanguage                 : return "App language"
        case .chooseLanguage              : return "Choose language"
        case .cancelTitle                 : return "Cancel"
        case .privcyPolicy                : return "Privcy policy"
        case .otherApps                   : return "Other apps"
        case .logOut                      : return "Log out"
        case .deleteAccaunt               : return "Delete accaunt"
        case .deleteAccauntWarningMessage : return "Are you sure that you want to delete your account ?"
        case .no                          : return "No"
        case .yes                         : return "Yes"
        case .firstNameTF                 : return "First name"
        case .lastNameTF                  : return "Last name"
            
            ///`           MapVC
        case .looking  : return "Looking..."
        case .moreInfo : return "More info"
            
            ///`        FilterVC
        case .priceRange: return "Price range"
        case .minimum   : return "Minimum"
        case .maximum   : return "Maximum"
        case .guestType : return "Guest type"
        case .famely    : return "Family"
        case .female    : return "Female"
        case .male      : return "Male"
        case .mix       : return "Mix"
        case .additional: return "Additional"
        case .alcohol   : return "Alcohol"
        case .verified  : return "Verified"
        case .clearAll  : return "Clear all"
        case .show      : return "Show"
            
            ///`           ContactVC
        case .contactUs           : return "Contact us"
        case .mainPage            : return "Main page"
        case .companyAdress       : return "Uzbekistan, Tashkent"
        case .companyAdressDetail : return "Mukhtar Ashrafi Street, 51"
        case .workingTimeForCall  : return "From Monday to Saturday from 9:00 to 18:00"
        case .sendAnyTime         : return "Send us a request at any time"
        case .enterNameTF         : return "Enter your name"
        case .enterEmailTF        : return "Enter your email"
        case .enterThemTF         : return "Enter theme"
        case .enterMessageTF      : return "Enter message"
        case .sendMessage         : return "Send message"
        case .doneToolButton      : return "Done"
        case .homeForBackButton   : return "Home"
        case .successfullySend    : return "Message is successfully sent"
        case .emptyField          : return "Empty field"
            
            ///`           ContactVC
        case .taxi               : return "Taxi"
        case .taxiType           : return "Taxi type"
        case .numberOfPassangers : return "Passangers"
        case .minimumConditions  : return "Minimum conditions"
        case .recommendedCars    : return "Recommended"
        case .cheaperCars        : return "Cheaper"
        case .expensiveCars      : return "Expensive"
            
            ///`           ChildrensServiceVC
        case .childrens      : return "Children"
        case .childrenEvents : return "Children events"
        case .images         : return "images"
            
            ///`           Intdoduction
        case .introductionForVillas          :  return "Stress-free stays, handcrafted for memories. Let's turn dream vacations into reality"
        case .introductionForTaxis           :  return "Say goodbye to waiting in line. Order your taxi with a tap and cruise in style"
        case .introductionForChildrenParties :  return "Forget boring birthdays! Build epic celebrations your kids will never forget"
        case .next                           :  return "Next"
            
            // additional
        case .all                   : return "All"
        case .contactAndComment     : return "Comment & contact"
        case .houses                : return "Villas"
        case .openYandexMap         : return "Open Yadex Map"
        case .noInternetMessage     : return "Not conected to the internet"
        }
    }
}

enum ClassType {
    //LanguageVC
    case selectLangLbl, getstartLangBtn
    //RegisterChildVC
    case getStartBtn
    //SignUpVC
    case signUpBtn
    //VerifyVC
    case phoneVerLbl, enterCodeLbl, verifyBtn
    //WelcomeVC
    case introLbl
    //Tabbar
    case menu, liked
    //HomeVC
    case searchTfPlaceholder, map, news, contacts, allCategory, all
    //HomeDetailVC
    case priceLbl, depositLbl, sumLbl, viewsLbl, hostedByLbl, peopleLbl, bedsLbl, bedroomsLbl, readMoreBtn, readLess,  locationLbl, chooseDayOfVacationLbl, fridayAndSaturday, otherDays, numberOfPeople, openLocation, openLocationMessage, contactAndComment
    //LikedVC
    case wishlists, wishlistsForBackBtn, delete, houses
    //ProfileVC
    case profileTitle, profileForBackBtn, user, showProfile, emptyTfError, saveBtn, settings, about, appLanguage, chooseLanguage, cancelTitle, privcyPolicy, otherApps, logOut, deleteAccaunt, deleteAccauntWarningMessage, no, yes, firstNameTF, lastNameTF, openYandexMap
    //HomeDetailVC
    case rules, additionalFeatures, showAllElementsBtn, additionaFeaturesOffers, commentByOwner, contactInfo, phoneLbl, comingTime, leavingTime, callBtn
    //MapVC
    case looking, moreInfo
    //FilterVC
    case priceRange, minimum, maximum, guestType, famely, female, male, mix, additional, alcohol, verified, clearAll, show
    //Contact
    case contactUs, mainPage, companyAdress, companyAdressDetail, workingTimeForCall, sendAnyTime, enterNameTF, enterEmailTF, enterThemTF, enterMessageTF, sendMessage, doneToolButton, homeForBackButton, successfullySend, emptyField
    //TaxiService
    case taxi, taxiType, numberOfPassangers, minimumConditions, recommendedCars, cheaperCars, expensiveCars
    //Childrens
    case childrens, childrenEvents, images
    //Intdoduction
    case introductionForVillas, introductionForTaxis, introductionForChildrenParties, next
    //Additional
    case noInternetMessage
}

