
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

protocol FiltredDelegate: AnyObject {
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
    let categoryNames = [SetLanguage.setLang(type: .allCategory),"Toshkent","Chorvoq","Chimyon","Qibray","Oq tosh"]
    var selectedRegion = SetLanguage.setLang(type: .allCategory)
    var filteredVillasID = [Int]()
    var houseDM = [HouseDM]()
    var searchedData = [HouseDM]()
    var isSelected = false
    var scrollFlag = false
    var allHouses = [CountryhouseData]()
    var allVillas = [CountryhouseData]()
    
    // variables for filtring
    var selectedMinimumPrice = 500000
    var selectedMaximumPrice = 15000000
    var selectedGuestType = [Int]()
    var selectedAdditionalFeatures = [Int]()
    var isUserSelectedAlcohol = false
    var isVerified = false
    var selectedNumberOfPeople: Int?
    
    var priceInterval: (minHousePrice: Int, maxHousePrice: Int) = (500000, 15000000)
        
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
//        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.backItem?.backButtonTitle = SetLanguage.setLang(type: .homeForBackButton)
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
        
        if allHouses.count != 0 {
            findPriceInterval()
        }
        
        vc.priceRange.minPrice = priceInterval.minHousePrice
        vc.priceRange.maxPrice = priceInterval.maxHousePrice
        
        present(vc, animated: true)
    }
        
    //MARK: - SHOW MAP
    @IBAction func showMap(_ sender: Any) {
        let vc = MapVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func newsBtn(_ sender: Any) {
        guard let botURL = URL.init(string: "https://bronla.uz/blog") else { return }
        UIApplication.shared.open(botURL)
    }
    
    @IBAction func contactsPressed(_ sender: Any) {
        let vc = ContactVC(nibName: "ContactVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    
    //MARK: - Functions
    
    func setupSearchTextField() {
        
        let imgView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imgView.tintColor = AppColors.mainColor
        imgView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        
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
        view.backgroundColor = AppColors.sar
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

        let layoutForColView: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutForColView.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutForColView.itemSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 355)
        layoutForColView.scrollDirection = .vertical
        print(UIScreen.main.bounds.width, "UIScreen.main.bounds.width")
        
        colView.collectionViewLayout = layoutForColView
        
        categoryColView.delegate = self
        categoryColView.dataSource = self

        let layoutForCategoryView: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutForCategoryView.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutForCategoryView.itemSize = CGSize(width: 110, height: 40)
        layoutForCategoryView.scrollDirection = .horizontal
        
        categoryColView.collectionViewLayout = layoutForCategoryView
        
        //register cell
        categoryColView.register(
            UINib(nibName: CategoryCVC.identifier, bundle: nil),
            forCellWithReuseIdentifier: CategoryCVC.identifier
        )
        
        colView.register(HomeCVC.self, forCellWithReuseIdentifier: HomeCVC.identifier)
        
        colView.backgroundColor = .clear
    }
    
    func getData() {
        Loader.start()
        API.getAllHouses { allHouses in
            guard let allHouses = allHouses else { return }
            
            self.allHouses = allHouses
            self.allVillas = allHouses
            self.colView.reloadData()
            Loader.stop()
        }
    }
    
    func findPriceInterval() {
        
        priceInterval.minHousePrice = allHouses.first!.priceForWorkingDays
        priceInterval.maxHousePrice = allHouses.first!.priceForWeekends
        
        for house in allHouses {
            if house.priceForWorkingDays < priceInterval.minHousePrice {
                priceInterval.minHousePrice = house.priceForWorkingDays
            } else if house.priceForWeekends > priceInterval.maxHousePrice {
                priceInterval.maxHousePrice = house.priceForWeekends
            }
        }
    }
    
    /// Search by tapped city category
    func searchByCategory(str: String) {
        allHouses = []
        var city = str
        
        if city == "Toshkent" {
            city.append(" sh.")
        }
        
        if !filteredVillasID.isEmpty {
            ///``    filtred
            if str != SetLanguage.setLang(type: .allCategory)   {
                for i in allVillas where i.province == city && filteredVillasID.contains(i.id) {
                    allHouses.append(i)
                }
            } else {
                for i in allVillas where filteredVillasID.contains(i.id) {
                    allHouses.append(i)
                }
            }
        } else {
            ///``  not filtred
            if str != SetLanguage.setLang(type: .allCategory) {
                for i in allVillas where i.province == city {
                    allHouses.append(i)
                }
            } else {
                allHouses = allVillas
            }
            
        }
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
            
            cell.updateCell(
                id: allHouses[indexPath.item].id,
                name: allHouses[indexPath.item].name,
                price: (allHouses[indexPath.item].priceForWorkingDays, allHouses[indexPath.item].priceForWeekends),
                location: allHouses[indexPath.item].province,
                images: allHouses[indexPath.item].images
            )
            
            cell.isVerified(
                v: allHouses[indexPath.item].approved,
                alco: allHouses[indexPath.item].alcohol,
                typeId: allHouses[indexPath.item].company.map({Companylist(id: $0.id, name: $0.name, image: $0.image)}),
                pool: []
            )

            cell.backgroundColor = .clear
            
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
        allHouses = []
        if let name = searchTF.text {
            if name.replacingOccurrences(of: " ", with: "") != "" {
                for i in allVillas {
                    let houseName = i.name.lowercased().replacingOccurrences(of: " ", with: "")
                    let searchName = name.lowercased().replacingOccurrences(of: " ", with: "")
                    if houseName.contains(searchName) {
                        allHouses.append(i)
                    }
                }
            } else {
                allHouses = allVillas
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
        vc.price.weekday = price.weekend
        vc.price.wrking = price.working
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

//MARK: FiltredDelegate
extension HomeVC: FiltredDelegate {
    
    func filtrData(minPrice: Int, maxPrice: Int, guestType: [Int], additionalFetures: [Int], isAllowedAlcohol: Bool, isVerified: Bool, numberOfPeople: Int?) {
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
        allHouses = []
        allVillas.forEach { house in
            if isFiltered(house) {
                allHouses.append(house)
            }
        }
        
        colView.reloadData()
        Loader.stop()
    }
}





