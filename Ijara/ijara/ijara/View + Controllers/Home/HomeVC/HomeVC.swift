
//
//  HomeVC.swift
//  ijara
//
//  Created by Muslim on 24/08/23.
//

import UIKit
import CoreLocation

enum ScrollState {
    case up
    case down
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var categoryColView: UICollectionView!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    @IBOutlet var topViews: [UIView]!
    var scrollFlag = false
    let locationManager = CLLocationManager()

    
    // temporary
    let categoryNames = ["Hamma","Toshkent","Chorvoq","Chimyon","Qibray","Oq tosh"]
    var houseDM = [HouseDM]()
    var searchedData = [HouseDM]()
    var timer: Timer? = nil
    var isSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColView()
        setupSubviews()
        locationManager.requestWhenInUseAuthorization()
        getData()
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
        present(vc, animated: true)
        vc.houseDM = houseDM
    }
    
    
    //MARK: - Setup Functions
    
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
        
        searchTF.leftView = leftView
        searchTF.leftViewMode = .always
        searchTF.layer.cornerRadius = searchTF.frame.height / 3
        searchTF.clipsToBounds = true
        searchTF.backgroundColor = AppColors.customGray6
    }
    
    func setupSubviews() {
        
        searchTF.delegate = self
        
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
    
    // get data from userdefaults
    func getData() {
        if let savedHouse = UserDefaults.standard.object(forKey: Keys.houseData) as? Data {
            let decoder = JSONDecoder()
            if let houses = try? decoder.decode([HouseDM].self , from: savedHouse) {
                houseDM = houses
                searchedData = houseDM
            }
        }
    }
    
    // searches by tapped city category
    func searchByCategory(str: String) {
        searchedData = []
        
        if str != "Hamma" {
            var city = str
            if city == "Toshkent" {
                city.append(" sh.")
            }
            for i in houseDM where i.province == city {
                searchedData.append(i)
            }
        } else {
            searchedData = houseDM
        }
        colView.reloadData()
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
            return searchedData.count
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
            cell.id = searchedData[indexPath.row].id
            cell.nameLbl.text = searchedData[indexPath.row].name
            cell.pirceLbl.text = "\(searchedData[indexPath.row].workingdays)" + "/" + " " + "\(searchedData[indexPath.row].weekends)" + "so'm"
            let workingDay = Int(searchedData[indexPath.row].workingdays.replacingOccurrences(of: " ", with: ""))!
            let weekend = Int(searchedData[indexPath.row].weekends.replacingOccurrences(of: " ", with: ""))!
            cell.price = (working: workingDay, weekend: weekend)
            cell.locationLbl.text = searchedData[indexPath.row].province
            cell.isVerified(v: searchedData[indexPath.row].approved,
                            alco: searchedData[indexPath.row].alcohol,
                            typeId: searchedData[indexPath.row].companylist,
                            pool: searchedData[indexPath.row].swimmingpool)
            cell.configureCell()
            cell.images = searchedData[indexPath.row].images
            
            return cell
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        // changes unselected category background
        if collectionView == categoryColView {
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
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
            vc.images = searchedData[indexPath.row].images
            vc.id = "\(searchedData[indexPath.row].id)"
            vc.price.weekday = Int(searchedData[indexPath.row].weekends.replacingOccurrences(of: " ", with: ""))!
            vc.price.wrking = Int(searchedData[indexPath.row].workingdays.replacingOccurrences(of: " ", with: ""))!
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
                return CGSize(width: view.frame.width - 24, height: 300)
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

extension HomeVC: CellDelegate {
    func cellSelected(id: String, images: [String], price: (working: Int, weekend: Int)) {
        let vc = HomeDetailVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        vc.images = images
        vc.id = id
        vc.price.weekday = price.weekend
        vc.price.wrking = price.working
    }
}
