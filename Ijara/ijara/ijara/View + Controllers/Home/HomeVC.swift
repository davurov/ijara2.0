
//
//  HomeVC.swift
//  ijara
//
//  Created by Muslim on 24/08/23.
//

import UIKit

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
    
    // temporary
    let categoryNames = ["Toshkent","Chorvoq","Chimyon","Qibray","Oqtosh"]
    var houseDM = [HouseDM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColView()
        setupSubviews()
        navigationController?.navigationBar.isHidden = true
        getData()
    }
    
    //MARK: - @IBActions
    
    @IBAction func filterBtnPressed(_ sender: UIButton) {
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
            }
        }
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
            return houseDM.count
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
            
            // cell data configure
            cell.categoryNameLbl.text = categoryNames[indexPath.row]
            
            return cell
        } else {
            let cell = colView.dequeueReusableCell(withReuseIdentifier: HomeCVC.identifier, for: indexPath) as! HomeCVC
            
            cell.nameLbl.text = houseDM[indexPath.row].name
            cell.pirceLbl.text = houseDM[indexPath.row].workingdays + "/" + " " + houseDM[indexPath.row].weekends + "so'm"
            cell.locationLbl.text = houseDM[indexPath.row].province
            cell.isVerified(v: houseDM[indexPath.row].approved,
                            alco: houseDM[indexPath.row].alcohol,
                            typeId: houseDM[indexPath.row].companylist,
                            pool: houseDM[indexPath.row].swimmingpool)
            cell.configureCell()
            if houseDM[indexPath.row].name == "Hasan husan" {
                print(houseDM)
            }
            return cell
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        // changes unselected category background
        if collectionView == categoryColView {
            let selectedCell = categoryColView.cellForItem(at: indexPath) as! CategoryCVC
            selectedCell.containerView.backgroundColor = AppColors.mainColor
            selectedCell.categoryNameLbl.textColor = .white
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        // changes selected category background
        if collectionView == categoryColView {
            let selectedCell = categoryColView.cellForItem(at: indexPath) as! CategoryCVC
            selectedCell.containerView.backgroundColor = .clear
            selectedCell.categoryNameLbl.textColor = .black
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView.contentOffset.y)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
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
