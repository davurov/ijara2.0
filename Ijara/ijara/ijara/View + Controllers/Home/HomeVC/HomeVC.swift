
//
//  HomeVC.swift
//  ijara
//
//  Created by Muslim on 24/08/23.
//

import UIKit
import CoreLocation
import SwiftyJSON

enum ScrollState {
    case up
    case down
}

protocol FiltredDelegate {
    func filtrData(minPrice: Int, maxPrice: Int, guestType: [Int], additionalFetures: [Int], isAllowedAlcohol: Bool, isVerified: Bool, numberOfPeople: Int?)
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var categoryColView: UICollectionView!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet var topViews: [UIView]!
    
    @IBOutlet weak var mapLbl: UILabel!
    @IBOutlet weak var newsLbl: UILabel!
    @IBOutlet weak var contactsLbl: UILabel!
    
    //MARK: Variables
    
    let locationManager = CLLocationManager()
    // temporary
    let categoryNames = ["Hamma","Toshkent","Chorvoq","Chimyon","Qibray","Oq tosh"]
    var selectedRegion = "Hamma"
    var filteredVillasID = [Int]()
    var houseDM = [HouseDM]()
    var searchedData = [HouseDM]()
    var timer: Timer? = nil
    var isSelected = false
    var scrollFlag = false
    var allHouses = [CountryhouseData]()
    var allVillas = [CountryhouseData]()
    var allVillasID = [Int]()
    
    var selectedMinimumPrice = 500000
    var selectedMaximumPrice = 15000000
    var selectedGuestType = [Int]()
    var selectedAdditionalFeatures = [Int]()
    var isUserSelectedAlcohol = false
    var isVerified = false
    var selectedNumberOfPeople: Int?
    
    //MARK: Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupColView()
        setupSubviews()
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - @IBActions
    
    @IBAction func filterBtnPressed(_ sender: UIButton) {
        let vc = FiltrVC()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [ .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        vc.filtrDelegate = self
        present(vc, animated: true)
        vc.houseDM = houseDM
    }
        
    //MARK: - SHOW MAP
    @IBAction func showMap(_ sender: Any) {
        let vc = MapVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true) 
        vc.houseDM = houseDM
        
    }
    
    @IBAction func newsBtn(_ sender: Any) {
        guard let botURL = URL.init(string: "https://bronla.uz/blog") else { return }
        UIApplication.shared.open(botURL)
    }
    
    
    @IBAction func contactsPressed(_ sender: Any) {
        guard let botURL = URL.init(string: "https://bronla.uz/contact") else { return }
        UIApplication.shared.open(botURL)
    }
    
    //MARK: - Functions
    
    func setupSearchTextField() {
        
        let imgView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imgView.tintColor = AppColors.mainColor
        imgView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let leftView = UIView(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 52,
                                            height: 52))
        leftView.addSubview(imgView)
        imgView.center = leftView.center
        
        searchTF.placeholder = SetLanguage.setLang(type: .searchTfPlaceholder)
        searchTF.leftView = leftView
        searchTF.leftViewMode = .always
        searchTF.layer.cornerRadius = searchTF.frame.height / 3
        searchTF.clipsToBounds = true
        searchTF.backgroundColor = AppColors.customGray6
        searchTF.placeholder = SetLanguage.setLang(type: .searchTfPlaceholder)
        searchTF.delegate = self
        
        colView.reloadData()
    }
    
    func setupSubviews() {
        
        filterBtn.layer.borderWidth = 1
        filterBtn.layer.borderColor = AppColors.mainColor.cgColor
        filterBtn.layer.cornerRadius = filterBtn.frame.height / 3
        filterBtn.clipsToBounds = true
        
        setupSearchTextField()
        
        for i in 0..<topViews.count {
            topViews[i].clipsToBounds = true
            topViews[i].layer.cornerRadius = 16
            
            topViews[i].layer.masksToBounds = false
            
            topViews[i].layer.shadowColor = UIColor.lightGray.cgColor
            topViews[i].layer.shadowRadius = 6
            topViews[i].layer.shadowOffset = CGSize(width: 6, height: 6)
            topViews[i].layer.shadowOpacity = 0.6
        }
        
        mapLbl.text      = SetLanguage.setLang(type: .map)
        newsLbl.text     = SetLanguage.setLang(type: .news)
        contactsLbl.text = SetLanguage.setLang(type: .contacts)
    }
    
    func setupColView() {
        colView.delegate = self
        colView.dataSource = self
        
        categoryColView.delegate = self
        categoryColView.dataSource = self
        
        //register cell
        categoryColView.register(UINib(nibName: CategoryCVC.identifier,
                                       bundle: nil),
                                 forCellWithReuseIdentifier: CategoryCVC.identifier)
        colView.register(UINib(nibName: HomeCVC.identifier,
                               bundle: nil),
                         forCellWithReuseIdentifier: HomeCVC.identifier)
        
        // setup Layout
        colView.setCollectionViewLayout(createCustomLayout(), animated: true)
    }
    
    func getData() {
        Loader.start()
        
        allVillasID = UserDefaults.standard.object(forKey: Keys.allVillas_Id) as? [Int] ?? []
        print("allVillasID in HomeVC")
//        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [self] in
            for villaID in allVillasID {
                API.getDetailDataByID(id: villaID) { villa in
                    guard let house = villa else {return }
                    self.allHouses.append(house)
                }
            }
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { [self] in
            allVillas = allHouses
            colView.reloadData()
            Loader.stop()
            print("allVillas.count:", allVillas.count, "allHouses.count:", allHouses.count, "in Home vc")
        }
    }
    
    /// Search by tapped city category
    func searchByCategory(str: String) {
        allHouses = []
//        searchedData = []
        var city = str
        
        if city == "Toshkent" {
            city.append(" sh.")
        }
        
        if !filteredVillasID.isEmpty {
            ///``    filtred
            if str != "Hamma" {
                for i in allVillas where i.province == city && filteredVillasID.contains(i.id) {
                    allHouses.append(i)
//                    searchedData.append(i)
                }
            } else {
                for i in allVillas where filteredVillasID.contains(i.id) {
                    allHouses.append(i)
//                    searchedData.append(i)
                }
            }
        } else {
            ///``  not filtred
            if str != "Hamma" {
                for i in allVillas where i.province == city {
                    allHouses.append(i)
//                    searchedData.append(i)
                }
            } else {
                allHouses = allVillas
//                searchedData = houseDM
            }
            
        }
        
//        if str != "Hamma" {
//            var city = str
//            if city == "Toshkent" {
//                city.append(" sh.")
//            }
//            for i in houseDM where i.province == city && filteredVillasID.contains(i.id) && filteredVillasID.count != 0 {
//                searchedData.append(i)
//            }
//        } else  {
//            for i in houseDM where filteredVillasID.contains(i.id) {
//                searchedData.append(i)
//            }
//        }
        colView.reloadData()
    }
    
    func isFiltered(_ house: CountryhouseData) -> Bool {
        ///# check price range
        if house.priceForWorkingDays < selectedMinimumPrice || house.priceForWeekends > selectedMaximumPrice {
            return false
        }

        ///# check guestType
        if !selectedGuestType.isContainsSelectedParamentr(house.companiesId()) {
            return false
        }
        
        ///# check additionFetures
        if !selectedAdditionalFeatures.isContainsSelectedParamentr(house.additionFeaturesId()) {
            return false
        }
        
        ///# check alcohol
        if isUserSelectedAlcohol && !house.alcohol {
            return false
        }
        
        ///# check approved
        if self.isVerified && !house.approved {
            return false
        }
        
        ///# check number of people
        if let numPeople = selectedNumberOfPeople {
            // user selected number of people
            if numPeople == 9 && house.numberofpeople <= 8 {
                return false
            } else if numPeople != 9 && numPeople != house.numberofpeople {
                return false
            }
        }
        
        return true
    }
    
}

//MARK: - Collection View Layout & Protocol Functions
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // layout
    func createCustomLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.createHomeSection()
        }
        
        let config: UICollectionViewCompositionalLayoutConfiguration = .init()
        config.scrollDirection = .vertical
        //        config.interSectionSpacing = 20
        
        layout.configuration = config
        return layout
    }
    
    // layout -> Headers
    func createHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            // height of header
            heightDimension: .absolute(52))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                     elementKind: "Header",
                                                                     alignment: .top)
        headerItem.pinToVisibleBounds = true
        return headerItem
    }
    
    // Layout -> Sections
    func createBannerSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                               heightDimension: .fractionalWidth(1/3)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1/3)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
    
    func createHomeSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = .init(top: 8,
                                   leading: 0,
                                   bottom: 8,
                                   trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .fractionalWidth(1.0)),
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryColView {
            return categoryNames.count
        } else {
            return allHouses.count
        }
    }
    
    // cell configuration
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryColView {
            let cell = categoryColView.dequeueReusableCell(withReuseIdentifier: "CategoryCVC", for: indexPath) as! CategoryCVC
            
            // cell configure
            
            cell.layer.cornerRadius = 12
            cell.clipsToBounds = true
            cell.sizeToFit()
            
            if !isSelected && indexPath.row == 0 {
                cell.containerView.backgroundColor = AppColors.mainColor
                cell.categoryNameLbl.textColor = .white
            }
            
            // cell data configure
            cell.categoryNameLbl.text = categoryNames[indexPath.row]
            
            return cell
        } else {
            let cell = colView.dequeueReusableCell(withReuseIdentifier: HomeCVC.identifier, for: indexPath) as! HomeCVC
            
            cell.cellDelegate = self
//            cell.id = allHouses[indexPath.item].id//searchedData[indexPath.row].id
//            cell.nameLbl.text = allHouses[indexPath.item].name//searchedData[indexPath.row].name
//            cell.pirceLbl.text = "\(searchedData[indexPath.row].workingdays)" + "/" + " " + "\(searchedData[indexPath.row].weekends)" + "so'm"
//            let workingDay = Int(searchedData[indexPath.row].workingdays.replacingOccurrences(of: " ", with: "")) ?? 0
//            let weekend = Int(searchedData[indexPath.row].weekends.replacingOccurrences(of: " ", with: "")) ?? 0
//            cell.price = (working: workingDay, weekend: weekend)
//            cell.locationLbl.text = allHouses[indexPath.item].province//searchedData[indexPath.row].province
//            cell.images = searchedData[indexPath.row].images
            
            cell.updateCell(
                id: allHouses[indexPath.item].id,
                name: allHouses[indexPath.item].name,
                price: (allHouses[indexPath.item].priceForWorkingDays, allHouses[indexPath.item].priceForWeekends),
                location: allHouses[indexPath.item].province,
                images: allHouses[indexPath.item].images
            )
            
            cell.isVerified(
                v: allHouses[indexPath.item].approved,  //searchedData[indexPath.row].approved,
                alco: allHouses[indexPath.item].alcohol,    //searchedData[indexPath.row].alcohol,
                typeId: allHouses[indexPath.item].company.map({Companylist(id: $0.id, name: $0.name, image: $0.image)}),
                pool: []   //searchedData[indexPath.row].swimmingpool
            )
            cell.configureCell()
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // changes unselected category background
        if collectionView == categoryColView {
            selectedRegion = categoryNames[indexPath.item]
            if !isSelected {
                let firstCell = categoryColView.cellForItem(at: IndexPath(row: 0, section: 0)) as? CategoryCVC
                firstCell?.containerView.backgroundColor = .clear
                firstCell?.categoryNameLbl.textColor = .black
                isSelected = true
            }
            let selectedCell = categoryColView.cellForItem(at: indexPath) as? CategoryCVC
            selectedCell?.containerView.backgroundColor = AppColors.mainColor
            selectedCell?.categoryNameLbl.textColor = .white
            searchByCategory(str: categoryNames[indexPath.row])
        } else {
            let vc = HomeDetailVC()
            vc.getData(id: allHouses[indexPath.row].id)
            vc.price.weekday = allHouses[indexPath.item].priceForWeekends
            vc.price.wrking = allHouses[indexPath.item].priceForWorkingDays
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // changes selected category background
        if collectionView == categoryColView {
            let selectedCell = categoryColView.cellForItem(at: indexPath) as? CategoryCVC
            selectedCell?.containerView.backgroundColor = .clear
            selectedCell?.categoryNameLbl.textColor = .black
        } else {
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView.contentOffset.y)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryColView {
                return CGSize(width: 100, height: 40)
            } else {
                return CGSize(width: view.frame.width - 24, height: 350)
            }
        }
}
//MARK: - HIDES AND UNHIDE TOPVIEW
extension HomeVC {
    func didScroll(_ y: CGFloat) {
        if y > 0 && scrollFlag == false {
            scrollFlag = true
            didScroll(state: .up)
        }
        
        if y < 0 && scrollFlag == true {
            scrollFlag = false
            didScroll(state: .down)
        }
    }
    
    func didScroll(state: ScrollState) {
        switch state {
        case .up:
            UIView.animate(withDuration: 0.5) { [self] in
                topContainer.transform = CGAffineTransform(scaleX: 0, y: 0)
                topContainer.isHidden = true
            }
        case .down:
            UIView.animate(withDuration: 0.5) {
                self.topContainer.transform = .identity
                self.topContainer.isHidden = false
            }
        }
    }
}

//MARK: TEXTFIELD

extension HomeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(self.serchByName),
            object: textField)
        self.perform(
            #selector(self.serchByName),
            with: textField,
            afterDelay: 0.5)
        return true
    }

    @objc func serchByName(textField: UITextField) {
        searchedData = []
        if let name = searchTF.text {
            if name.replacingOccurrences(of: " ", with: "") != "" {
                for i in houseDM {
                    let houseName = i.name.lowercased().replacingOccurrences(of: " ", with: "")
                    let searchName = name.lowercased().replacingOccurrences(of: " ", with: "")
                    if houseName.contains(searchName) {
                        searchedData.append(i)
                    }
                }
            } else {
                searchedData = houseDM
            }
        }
        colView.reloadData()
    }
    
}

//MARK: CellDelegate
extension HomeVC: CellDelegate {
    func cellSelected(id: Int, images: [String], price: (working: Int, weekend: Int)) {
        let vc = HomeDetailVC()
        vc.getData(id: id)
        print(id, "id in homeVC ")
        vc.price.weekday = price.weekend//allHouses[indexPath.item].priceForWeekends
        vc.price.wrking = price.working//allHouses[indexPath.item].priceForWorkingDays
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
//        let vc = HomeDetailVC()
//        vc.modalPresentationStyle = .overFullScreen
//        present(vc, animated: true)
//        vc.images = images
//        vc.id = Int(id) ?? 0
//        vc.price.weekday = price.weekend
//        vc.price.wrking = price.working
    }
}

//MARK: FiltredDelegate
extension HomeVC: FiltredDelegate {
    
    func filtrData(minPrice: Int, maxPrice: Int, guestType: [Int], additionalFetures: [Int], isAllowedAlcohol: Bool, isVerified: Bool, numberOfPeople: Int?) {
        print(minPrice, maxPrice, "got from protocol func filtrData")
        Loader.start()
        
        selectedMinimumPrice = minPrice
        selectedMaximumPrice = maxPrice
        selectedGuestType = guestType
        selectedAdditionalFeatures = additionalFetures
        isUserSelectedAlcohol = isAllowedAlcohol
        self.isVerified = isVerified
        selectedNumberOfPeople = numberOfPeople
        filteredVillasID = []
        
        // get houses by id
        allVillasID.forEach { id in
            API.getDetailDataByID(id: id) { [self] detailData in
                
                guard let detailData = detailData else { return }
                
                if isFiltered(detailData) {
                    filteredVillasID.append(detailData.id)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            
            allHouses = []
            allVillas.forEach { house in
                if self.filteredVillasID.contains(house.id) {
                    allHouses.append(house)
                }
            }
            colView.reloadData()
            Loader.stop()
            
        }
        
    }
}

extension Array {
    func isContainsSelectedParamentr(_ arr: [Int]) -> Bool {
        for i in self as! [Int] {
            if !arr.contains(i) {
                return false
            }
        }
        return true
    }
}

//        allVillasID = [
//            1, 93, 151, 358, 295, 198, 315, 203, 569, 402, 567, 574, 568, 560, 236, 202, 571, 22, 323, 16, 119, 284, 540, 123, 561, 248, 501, 357, 81, 269, 538, 281, 293
//        ]
