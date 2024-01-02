
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

/// `FiltredDelegate` to get parametrs which user selected in `FiltrVC`
protocol FiltredDelegate: AnyObject {
    func filtrData(minPrice: Int, maxPrice: Int, guestType: [Int], additionalFetures: [Int], isAllowedAlcohol: Bool, isVerified: Bool, numberOfPeople: Int?)
}

/// `HomeViewProtocol` for set values which recived form `HomePresenter`
protocol HomeViewProtocol: AnyObject {
    func setHouses(houses: [CountryhouseData]?)
    func setPirceInterval(min: Int, max: Int)
    func searchedHouses(houses: [CountryhouseData])
    func sortedHousesByProvince(sortedHouses: [CountryhouseData])
    func setFiltredHouses(filtredHouses: [CountryhouseData])
}

class HomeVC: UIViewController, HomeViewProtocol {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var categoryColView: UICollectionView!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet var topViews: [UIView]!
    @IBOutlet weak var mapLbl: UILabel!
    @IBOutlet weak var newsLbl: UILabel!
    @IBOutlet weak var contactsLbl: UILabel!
    
    @IBOutlet weak var housesLbl: UILabel!
    
    @IBOutlet weak var allBtn: UIButton!
    
    //MARK: Variables
    private var homePresenter: HomePresenter {
        return HomePresenter(view: self)
    }
    
    let locationManager = CLLocationManager()
    let categoryNames =  SetLanguage.setTranslatedCategories()
    var selectedRegion = SetLanguage.setLang(type: .allCategory)
    var filteredVillasID = [Int]()
    var isSelected = false
    var scrollFlag = false
    
    /// `allHouses` can be change according to filtring, sorting, searching
    var allHouses = [CountryhouseData]()
    
    /// `allVillas` will change only one time when got houses form server
    var allVillas = [CountryhouseData]()
    
    var filtrModel = FiltrHousesModel()
    
    var priceInterval: (minHousePrice: Int, maxHousePrice: Int) = (500000, 15000000)
    
    var isConfigured = false
    
    //MARK: Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        locationManager.requestWhenInUseAuthorization()
        setupSubviews()
        setupColView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isConfigured {
            getData()
            isConfigured = true
        }
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        navigationController?.navigationBar.backgroundColor = .white
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
            homePresenter.findPriceInterval(from: allHouses)
        }
        
        vc.priceRange.minPrice = priceInterval.minHousePrice
        vc.priceRange.maxPrice = priceInterval.maxHousePrice
        
        present(vc, animated: true)
    }
        
    //MARK: - SHOW MAP
    @IBAction func showMap(_ sender: Any) {
        let vc = MapVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func newsBtn(_ sender: Any) {
        
        let vc = NewsVC()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [ .medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        present(vc, animated: true)
    }
    
    @IBAction func contactsPressed(_ sender: Any) {
        let vc = ContactVC(nibName: "ContactVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func allPressed(_ sender: Any) {
        let vc = AllHousesVC()
        vc.setValues(allVillas)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
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
        searchTF.returnKeyType = .done
        
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
        
        housesLbl.text = "  " + SetLanguage.setLang(type: .houses)
        
        allBtn.setTitleColor(AppColors.selectedTabbarCollor, for: .normal)
        allBtn.setTitle("\(SetLanguage.setLang(type: .all))", for: .normal)
    }
    
    func setupColView() {
        colView.delegate = self
        colView.dataSource = self

        let layoutForColView: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutForColView.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutForColView.itemSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 355)
        layoutForColView.scrollDirection = .vertical
        
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
        homePresenter.getHouses()
    }
    
    func findPriceInterval() {
        homePresenter.findPriceInterval(from: allHouses)
    }
    
    /// Search by tapped city category
    func searchByCategory(str: String) {
        var city = str
        
        if city == "Toshkent" {
            city.append(" sh.")
        }
        
        homePresenter.sortByProvince(with: allVillas, province: city)
    }
    
}

//MARK: - HomeViewDelegate

extension HomeVC {
    func setHouses(houses: [CountryhouseData]?) {
        guard let houses  = houses else { return }
        
        allHouses = houses
        allVillas = allHouses
        colView.reloadData()
        Loader.stop()
    }
    
    func setPirceInterval(min: Int, max: Int) {
        priceInterval.minHousePrice = min
        priceInterval.maxHousePrice = max
    }
    
    func searchedHouses(houses: [CountryhouseData]) {
        allHouses = houses
        colView.reloadData()
    }
    
    func sortedHousesByProvince(sortedHouses: [CountryhouseData]) {
        allHouses = sortedHouses
        colView.reloadData()
    }
    
    func setFiltredHouses(filtredHouses: [CountryhouseData]) {
        allHouses = filtredHouses
        colView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            Loader.stop()
        }
    }
    
}

//MARK: - Collection View Layout & Protocol Functions
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            cell.imageDatas = allHouses[indexPath.item].imagesAsData
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
            vc.hidesBottomBarWhenPushed = true
            vc.navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.pushViewController(vc, animated: true)
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
        if let name = searchTF.text {
            homePresenter.searchByKey(from: allVillas, searchKey: name, province: selectedRegion)
        }
    }
}

//MARK: CellDelegate
extension HomeVC: CellDelegate {
    func cellSelected(id: Int, images: [String], price: (working: Int, weekend: Int)) {
        let vc = HomeDetailVC()
        vc.getData(id: id)
        vc.price.weekday = price.weekend
        vc.price.wrking = price.working
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: FiltredDelegate
extension HomeVC: FiltredDelegate {
    
    func filtrData(minPrice: Int, maxPrice: Int, guestType: [Int], additionalFetures: [Int], isAllowedAlcohol: Bool, isVerified: Bool, numberOfPeople: Int?) {
        
        Loader.start()
        
        filtrModel = FiltrHousesModel(
            selectedMinimumPrice       : minPrice,
            selectedMaximumPrice       : maxPrice,
            selectedGuestType          : guestType,
            selectedAdditionalFeatures : additionalFetures,
            isUserSelectedAlcohol      : isAllowedAlcohol,
            isVerified                 : isVerified,
            selectedNumberOfPeople     : numberOfPeople
        )
        
        homePresenter.filtrHouses(with: allHouses, filtrParametrs: filtrModel, province: selectedRegion)
    }
}
