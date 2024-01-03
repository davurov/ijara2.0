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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var callCont: UIView!
    
    @IBOutlet weak var priceLbl: UILabel! {
        didSet {
            priceLbl.text = "\(SetLanguage.setLang(type: .priceLbl)): "
        }
    }
    @IBOutlet weak var depositLbl: UILabel! {
        didSet {
            depositLbl.text = "\(SetLanguage.setLang(type: .depositLbl)): "
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
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    
    var likeBtn: UIBarButtonItem!
    
    //MARK: Variables
    var previousContentOffset: CGFloat = 0.0
    var commentCellSize: CGFloat = 280
    var countryHouseDM: CountryhouseData?
    var images = [String]()
    var totalSum = 0 // to count price
    var dayCount = 0 // number of days in range
    var lastPeopleNum = 0
    
    var price = (wrking: 0 ,weekday: 0) {
        didSet {
            setPriceAnimation(weekwnds: price.weekday, workingdays: price.wrking)
        }
    }
    var id = 0
    
    //MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = countryHouseDM?.name
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    //MARK: @IBAction functions
    
    @IBAction func callPressed(_ sender: Any) {
        countryHouseDM?.firstphone.callNumber()
    }
    
    @objc func likeBtnPressed(){
        //change likedBtn
        guard let countryHouseDM = countryHouseDM else { return }
        
        let isLiked = LikedProducts.likedProducts.isLikedPerform(sevriceType: .house, id: countryHouseDM.id)
        likeBtn.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    @objc func shareBtnPressed(){
        shareRoute()
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
            setupTabbarButtons()
            tableView.reloadData()
        }
    }
    
    private func setupTabbarButtons(){
        likeBtn = UIBarButtonItem(
            image: UIImage(systemName: "heart"), style: .done,
            target: self, action: #selector(likeBtnPressed)
        )
        
        guard let countryHouseDM = countryHouseDM else { return }
        
        //find that house is liked or not
        let isLiked = LikedProducts.likedProducts.isLiked(sevriceType: .house, id: countryHouseDM.id)
        
        likeBtn.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        likeBtn.tintColor = AppColors.mainColor

        let shareBtn = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"), style: .done,
            target: self, action: #selector(shareBtnPressed)
        )
        
        shareBtn.tintColor = AppColors.mainColor
        navigationItem.rightBarButtonItems = [likeBtn, shareBtn]
    }
    
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(PhotoTVC.nib(), forCellReuseIdentifier: PhotoTVC.identifier)
        tableView.register(NameTVC.self, forCellReuseIdentifier: NameTVC.identifier)
        tableView.register(RulesTVC.nib(), forCellReuseIdentifier: RulesTVC.identifier)
        tableView.register(AdditionalTVC.nib(), forCellReuseIdentifier: AdditionalTVC.identifier)
        tableView.register(InfoTVC.nib(), forCellReuseIdentifier: InfoTVC.identifier)
        tableView.register(CalendarTVC.nib(), forCellReuseIdentifier: CalendarTVC.identifier)
        tableView.register(MapTVC.nib(), forCellReuseIdentifier: MapTVC.identifier)
        title = countryHouseDM?.name
        
        callCont.addShadowByHand(offset: CGSize(width: 0, height: 0), color: AppColors.customBlack.cgColor, radius: 5, opacity: 0.3)
        callCont.layer.cornerRadius = 20
        callCont.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        let screenHeight = UIScreen.main.bounds.height
        bottomViewHeight.constant = screenHeight * 0.11
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
        rollingDigitsLabel?.setNumber(sum, animated: true)
        rollingDigits2?.setNumber(Int(Double(sum) * 0.4), animated: true, completion: nil)
    }
    
    func shareRoute(){
        let text = "https://bronla.uz/countryhouse/\(id)"
        let shareAll: [Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }

}

//MARK: - UITableViewDataSource
extension HomeDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotoTVC.identifier, for: indexPath) as! PhotoTVC
            
            guard let countryHouseDM = countryHouseDM else { return photoCell }
            
            photoCell.updateCell(countryHouseDM.images)
            photoCell.allImagesDelegate = self
            photoCell.isWithRadiusPhoto = false
            
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
                "\(countryHouseDM.bedroomsrooms) \(SetLanguage.setLang(type: .bedroomsLbl))",
                "\(countryHouseDM.numberofpeople) \(SetLanguage.setLang(type: .peopleLbl))"
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
        let screenHeigh = UIScreen.main.bounds.height
        
        if indexPath.row == 0 {
            if screenHeigh > 750 {
                return 300
            } else {
                return 300 - 30
            }
            //screenHeigh * 0.321
        } else if indexPath.row == 1 {
            return 110
        } else if indexPath.row == 2 {
            return 115
        } else if indexPath.row == 3 {
            guard let villa = countryHouseDM  else { return 250 }
                if villa.company.count == 3 || villa.company.count == 4 {
                    return 230
                } else {
                    return 130
                }
        } else if indexPath.row == 4 {
            return 415 //340
        } else if indexPath.row == 5 {
            return 575
        } else {
            return 300
        }
    }

}

extension HomeDetailVC {
    //IT TELLS WHEATER CELL IN THE SCREEN OR NOT
    func isCellVisible(indexPath: IndexPath) -> Bool {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            return visibleIndexPaths.contains(indexPath)
        }
        return false
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
    func openOwnerInfoVC() {
        guard let countryHouseDM = countryHouseDM else { return }

        let vc = OwnerInfoVC()
        vc.setValues(house: countryHouseDM)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        
        present(vc, animated: true)

        
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAllPressed() {
        let vc = AdditionalVC()
//        if let sheet = vc.sheetPresentationController {
//            sheet.detents = [.medium(), .large()]
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.prefersGrabberVisible = true
//            sheet.preferredCornerRadius = 24
//        }
//        present(vc, animated: true)
        vc.features = countryHouseDM?.entertainmentdata ?? []

        navigationController?.pushViewController(vc, animated: true)
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
        let weeks = dates?.map{$0.currentDay != 1 ? $0.currentDay - 1 : 7}
        
        totalSum = 0
        dayCount = (dates?.count ?? 0) - 1
        
        guard let weeks = weeks else { return }
        guard let countryHouseDM = countryHouseDM else { return }

        weeks.forEach({ i in
            if i == 5 || i == 6 {
                totalSum += countryHouseDM.priceForWeekends
            } else {
                totalSum += countryHouseDM.priceForWorkingDays
            }
        })
    
        changePrice(sum: totalSum)
        
    }
}

extension HomeDetailVC: AllImagesProtocol {
    func allPressed(_ images: [String]) {
        let vc = All_ImagesVC()
        vc.setImages(images)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func detailPressed(images: [String], selectedImageIndex: Int) {
        let vc = ImageDetailVC()
        vc.setImage(images: images, selectedImgIndex: selectedImageIndex)
        navigationController?.pushViewController(vc, animated: true)
    }
}
