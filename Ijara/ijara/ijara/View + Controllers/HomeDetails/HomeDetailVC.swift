//
//  HomeDetailVC.swift
//  ijara
//
//  Created by Abduraxmon on 16/09/23.
//

import UIKit
import CoreLocation
import RollingDigitsLabel

class HomeDetailVC: UIViewController {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableviewSafeConst: NSLayoutConstraint!
    @IBOutlet weak var callCont: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel! {
        didSet {
            priceLbl.text = SetLanguage.setLang(type: .priceLbl)
        }
    }
    @IBOutlet weak var depositLbl: UILabel! {
        didSet {
            depositLbl.text = SetLanguage.setLang(type: .depositLbl)
        }
    }
    @IBOutlet weak var sumLbl1: UILabel! {
        didSet {
            sumLbl1.text = SetLanguage.setLang(type: .sumLbl)
            sumLbl1.textColor = .red
//            sumLbl1.isHidden = true
        }
    }
    @IBOutlet weak var sumLbl2: UILabel! {
        didSet {
            sumLbl2.text = SetLanguage.setLang(type: .sumLbl)
            sumLbl2.textColor = .red
//            sumLbl2.isHidden = true
        }
    }
    @IBOutlet weak var callBtn: UIButton! {
        didSet {
            callBtn.setTitle(SetLanguage.setLang(type: .callBtn), for: .normal)
        }
    }
    
    @IBOutlet private var rollingDigitsLabel: RollingDigitsLabel? {
        didSet {
            rollingDigitsLabel?.numberStyle = .decimal
            rollingDigitsLabel?.set(font: .boldSystemFont(ofSize: 17))
            rollingDigitsLabel?.set(color: AppColors.mainColor)
        }
    }
    
    @IBOutlet weak var rollingDigits2: RollingDigitsLabel! {
        didSet {
            rollingDigits2.numberStyle = .decimal
            rollingDigits2.set(font: .boldSystemFont(ofSize: 17))
            rollingDigits2.set(color: AppColors.mainColor)
        }
    }
    
    //MARK: Variables
    var previousContentOffset: CGFloat = 0.0
    var commentCellSize : CGFloat = 280
    var countryHouseDM: CountryhouseData?
    var images = [String]()
    var totalSum = 0 // to count price
    var dayCount = 0 // number of days in range
    var lastPeopleNum = 0
    
//    var priceForWorkingDays = 0
//    var priceForWeekends = 0
    
    var price = (wrking: 0 ,weekday: 0) {
        didSet {
            setPriceAnimation(weekwnds: price.weekday, workingdays: price.wrking)
        }
    }
    var id = 0
//    "" {
//        didSet {
//            getData(id: Int(id) ?? 0)
//        }
//    }
    
    var likedHouses = UserDefaults.standard.array(forKey: Keys.likedHouses) as? [Int] ?? []
    
    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        API.isMap = false
    }
    
    //MARK: @IBAction functions
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func likePressed(_ sender: Any) {
        likePressed()
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        shareRoute()
    }
    
    @IBAction func callPressed(_ sender: Any) {
        countryHouseDM?.firstphone.callNumber()
    }
        
    //MARK: functions
    /// function to get houses from server by house id
    func getData(id: Int) {
        self.id = id
        Loader.start()
        API.getDetailDataByID(id: id) { [self] countryhouseData in
            Loader.stop()
            
            guard let detailData = countryhouseData else {
                print("can not get data")
                return
            }
            
            countryHouseDM = detailData
            setUpViews()
            tableView.reloadData()
        }
        
//        Firebase.getIdFromFirebase { token in
//            if let token = token {
//                API.getProducts(id: id, token: token) { data in
//                    if let data = data {
//                        print("getData func da API.getProducts ni comletion dan kelgan data -> \(data)")
//                        self.countryHouseDM = data
//                        self.tableView.reloadData()
//                    } else {
//                        Alert.showAlert(forState: .error, message: "Unable to ge data")
//                    }
//                }
//            }
//        }
    }
    
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PhotoTVC.nib(), forCellReuseIdentifier: PhotoTVC.identifier)
        tableView.register(NameTVC.nib(), forCellReuseIdentifier: NameTVC.identifier)
        tableView.register(RulesTVC.nib(), forCellReuseIdentifier: RulesTVC.identifier)
        tableView.register(AdditionalTVC.nib(), forCellReuseIdentifier: AdditionalTVC.identifier)
        tableView.register(InfoTVC.nib(), forCellReuseIdentifier: InfoTVC.identifier)
        tableView.register(CommentTVC.nib(), forCellReuseIdentifier: CommentTVC.identifier)
        tableView.register(ContactTVC.nib(), forCellReuseIdentifier: ContactTVC.identifier)
        tableView.register(CalendarTVC.nib(), forCellReuseIdentifier: CalendarTVC.identifier)
        tableView.register(MapTVC.nib(), forCellReuseIdentifier: MapTVC.identifier)
        
        navigationController?.navigationBar.isHidden = true
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let topPadding = window?.safeAreaInsets.top
        tableviewSafeConst.constant = -topPadding!
        
        callCont.addShadowByHand(offset: CGSize(width: 0, height: 0), color: AppColors.customBlack.cgColor, radius: 5, opacity: 0.2)
        callCont.layer.cornerRadius = 20
        callCont.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        guard let countryHouseDM = countryHouseDM else { return }
        
        let price = countryHouseDM.priceForWeekends
        sumLbl1.text = "\(price) \(SetLanguage.setLang(type: .sumLbl))"
        sumLbl2.text = "\(Double(price) * 0.4) \(SetLanguage.setLang(type: .sumLbl))"

        showLikeBtn()
        
    }
    
    func setPriceAnimation(weekwnds: Int, workingdays: Int) {
        var newNumber = 0
        if Date().currentDay == countryHouseDM?.weekday[0] || Date().currentDay == countryHouseDM?.weekday[1] {
            newNumber = weekwnds
        } else {
            newNumber = workingdays
        }
        rollingDigitsLabel?.setNumber(newNumber, animated: true, completion: nil)
        rollingDigits2?.setNumber(Int(Double(newNumber) * 0.4), animated: true, completion: nil)
    }
    
    func changePrice(sum: Int) {
        rollingDigitsLabel?.setNumber(sum, animated: true, completion: nil)
        rollingDigits2?.setNumber(Int(Double(sum) * 0.4), animated: true, completion: nil)
    }
    
    func shareRoute(){
        let text = "https://bronla.uz/countryhouse/\(id)"
        let shareAll: [Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showLikeBtn() {
        if likedHouses.contains(id) {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    /// func for liked or unliked houses
    func likePressed() {
        if likedHouses.contains(id) {
            let index = likedHouses.firstIndex(of: id) ?? 0
            likedHouses.remove(at: index)
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likedHouses.append(id)
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        UserDefaults.standard.set(likedHouses, forKey: Keys.likedHouses)
        
    }
    
}

//MARK: - UITableViewDataSource
extension HomeDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as! PhotoTVC
            
            guard let countryHouseDM = countryHouseDM else { return photoCell }
            
            photoCell.updateCell(countryHouseDM.images)
 
            return photoCell
        } else if indexPath.row == 1 {
            let nameCell = tableView.dequeueReusableCell(withIdentifier: NameTVC.identifier, for: indexPath) as! NameTVC
            
            guard let countryHouseDM = countryHouseDM else { return nameCell }
            
            nameCell.updateCell(
                countryHouseDM.name,
                countryHouseDM.province + ", " + countryHouseDM.address,
                "\(countryHouseDM.reyting)   ·",
                "\(countryHouseDM.seen) \(SetLanguage.setLang(type: .viewsLbl))"
            )
            
            return nameCell
        } else if indexPath.row == 2 {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: InfoTVC.identifier, for: indexPath) as! InfoTVC
            
            guard let countryHouseDM = countryHouseDM else { return infoCell }
            
            infoCell.updateCell(
                "\(SetLanguage.setLang(type: .hostedByLbl)) " + countryHouseDM.owner,
                "\(countryHouseDM.sleeping) \(SetLanguage.setLang(type: .bedsLbl))",
                "\(countryHouseDM.bedroomsrooms) \(SetLanguage.setLang(type: .bedroomsLbl)) | ",
                "\(countryHouseDM.numberofpeople) \(SetLanguage.setLang(type: .peopleLbl)) | "
            )
            
            return infoCell
        } else if indexPath.row == 3 {
            let rulesCell = tableView.dequeueReusableCell(withIdentifier: RulesTVC.identifier, for: indexPath) as! RulesTVC
            guard let countryHouseDM = countryHouseDM else { return rulesCell }
            
            rulesCell.updateCell(countryHouseDM.company)
            
            return rulesCell
        } else if indexPath.row == 4 {
            let additionalCell = tableView.dequeueReusableCell(withIdentifier: AdditionalTVC.identifier, for: indexPath) as! AdditionalTVC
            
            guard let countryHouseDM = countryHouseDM else { return additionalCell }
            
            additionalCell.delegate = self
            additionalCell.updateCell(countryHouseDM.entertainmentdata)
            
            return additionalCell
        } else if indexPath.row == 5 {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: CommentTVC.identifier, for: indexPath) as! CommentTVC
            
            guard let countryHouseDM = countryHouseDM else { return commentCell }
            
            commentCell.delegate = self
            commentCell.updateCell(countryHouseDM.comment)

            return commentCell
        } else if indexPath.row == 6 {
            let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactTVC.identifier, for: indexPath) as! ContactTVC
         
            guard let countryHouseDM = countryHouseDM else { return contactCell }
            
            contactCell.updateCell(
                countryHouseDM.firstphone,
                countryHouseDM.secondphone,
                countryHouseDM.startTime,
                countryHouseDM.finishTime
            )
            
            return contactCell
        } else if indexPath.row == 7 {
            let calendarCell = tableView.dequeueReusableCell(withIdentifier: CalendarTVC.identifier, for: indexPath) as! CalendarTVC
            
            guard let countryHouseDM = countryHouseDM else { return calendarCell }
            
            calendarCell.delegate = self
            calendarCell.updateCell(countryHouseDM.priceForWorkingDays, countryHouseDM.priceForWeekends)

            return calendarCell
        } else {
            let mapCell = tableView.dequeueReusableCell(withIdentifier: MapTVC.identifier, for: indexPath) as! MapTVC
            guard let countryHouseDM = countryHouseDM else { return mapCell }
            
            mapCell.delegate = self
            
            mapCell.updateCell(
                countryHouseDM.listlocation.first ?? 0,
                countryHouseDM.listlocation.last ?? 0
            )
            
            mapCell.addMapPin(with: CLLocation(
                latitude: countryHouseDM.listlocation.first ?? 0, longitude: countryHouseDM.listlocation.last ?? 0
            ))
            
            return mapCell
        }
    }
}

//MARK: - UITableViewDelegate
extension HomeDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else if indexPath.row == 1 {
            return 110
        } else if indexPath.row == 2 {
            return 80
        } else if indexPath.row == 3 {
            guard let villa = countryHouseDM  else { return 250 }
                if villa.company.count == 3 || villa.company.count == 4 {
                    return 230
                } else {
                    return 120
                }
        } else if indexPath.row == 4 {
            return 340
        } else if indexPath.row == 5 {
            return commentCellSize
        } else if indexPath.row == 6 {
            return 230
        } else if indexPath.row == 7 {
            return 520
        } else {
            return 300
        }
    }

}

extension HomeDetailVC {
    //TELS WHEATER CELL IN THE SCREEN OR NOT
    func isCellVisible(indexPath: IndexPath) -> Bool {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            return visibleIndexPaths.contains(indexPath)
        }
        return false
    }
}

//MARK: - UIScrollViewDelegate
extension HomeDetailVC: UIScrollViewDelegate {
    //MARK: - TELLS SCROLLED UP OR DAWN
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = scrollView.contentOffset.y
        //WORKES WHEN WHEN SWIPED DAWN AND NOT 0 CELL IS NOT ON SCREEN
        if currentContentOffset > previousContentOffset && !navView.isHidden && !isCellVisible(indexPath: IndexPath(row: 0, section: 0)) {
            // IF SCROLLED DAWN IT HIDES VIEW
            UIView.animate(withDuration: 0.3) {
                self.navView.alpha = 0.0
            }
        } else if currentContentOffset < previousContentOffset && (navView.alpha == 0 || isCellVisible(indexPath: IndexPath(row: 0, section: 0))) {
            //SHOWS NAVVIEW BUT COLOR IS CLEAR
            if !isCellVisible(indexPath: IndexPath(row: 0, section: 0))  {
                navView.backgroundColor = AppColors.mainColor
            } else {
                //SHOWS NAVVIEW BUT COLOR IS MAIN COLOR
                UIView.transition(with: navView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.navView.backgroundColor = .clear
                }, completion: nil)
            }
            UIView.animate(withDuration: 0.3) {
                self.navView.alpha = 1.0
            }
        }
        
        previousContentOffset = currentContentOffset
    }
}

//MARK: - CommentDelegate
extension HomeDetailVC: CommentDelegate {
    func readMorePressed(size: CGFloat) {
        commentCellSize = size
        tableView.reloadData()
    }
}

//MARK: - MapDelegate
extension HomeDetailVC: MapDelegate {
    func mapPressed(lat: Double, long: Double) {
        OpenMapDirections.present(in: self,latitude: lat,longitude: long, sourceView: UIView())
    }
}

//MARK: - AdditionalDelegate
extension HomeDetailVC: AdditionalDelegate {
    func showAllPressed() {
        let vc = AdditionalVC()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        present(vc, animated: true)
        vc.features = countryHouseDM?.entertainmentdata ?? []
    }
}

//MARK: - RangeDelegate
extension HomeDetailVC: RangeDelegate {
    func personAdded(num: Int) {
        let diff = num - (countryHouseDM?.numberofpeople ?? 0)
        if (countryHouseDM?.numberofpeople ?? 0) <= num && dayCount > 0 {
            changePrice(sum: totalSum + (diff * (dayCount * 200000)))
        } else if lastPeopleNum > (countryHouseDM?.numberofpeople ?? 0) && lastPeopleNum != lastPeopleNum - 1 && dayCount > 0  {
            // if changed number of people from textfield
            changePrice(sum: totalSum)
        }
        lastPeopleNum = num
    }
    
    func rangeSelected(dates: [Date]?) {
        var weeks = dates?.map{$0.currentDay != 1 ? $0.currentDay - 1 : 7}
        weeks?.removeLast()
        totalSum = 0
        dayCount = (dates?.count ?? 0) - 1
        weeks?.forEach({ i in
            if i == countryHouseDM?.weekday[0] || i == countryHouseDM?.weekday[1] {
                totalSum += price.weekday
//                print(price.weekday)
            } else {
                totalSum += price.wrking
//                print(price.wrking)
            }
        })
        
        changePrice(sum: totalSum)
    }
}
