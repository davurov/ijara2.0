//
//  LikedHousesVC.swift
//  ijara
//
//  Created by Abduraxmon on 12/09/23.
//

import UIKit
import Lottie

class LikedHousesVC: UIViewController {
    
    @IBOutlet weak var wishlistsLbl: UILabel!
    @IBOutlet weak var categoriesSegmen: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    
    //MARK: Variables
    let userDef = UserDefaults.standard
    
    var likedHousesID = [Int]()
    var likedPartiesIDs: [Int] = []
    var likedTaxisIDs: [Int] = []
    
    var allHouses: [CountryhouseData] = []
    var allTaxis: [TaxiDM] = []
    var allParties: [ChildrensParty] = []
    
    var likedHouses = [CountryhouseData]()
    var likedTaxiServices = [TaxiDM]()
    var likedChildrenParties = [ChildrensParty]()

    var lottieView = LottieAnimationView()
    var selectedCategory: ServiceType = .house
    
    var serviceRespondCounter = 0
    
    let dispatchGroup = DispatchGroup()
    let queue1 = DispatchQueue.global(qos: .userInitiated)
    let queue2 = DispatchQueue.global(qos: .userInitiated)
    let queue3 = DispatchQueue.global(qos: .userInitiated)
    
    
    //MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Loader.start()

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        wishlistsLbl.text = SetLanguage.setLang(type: .wishlists)
        title = SetLanguage.setLang(type: .wishlists)
        
        getAllTaxiServices()
        getAllHouses()
        getAllParties()
        
        var timer: Timer?
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: {[weak self] _ in
            guard let self = self else { return }
            
            //for example: taxi or party get load faster then others, to reload all 3 type we should wait until all liked products loaded. Therefor we are check every 0.15 second, after got all liked products we can reload tableView.
            if serviceRespondCounter == 3 {
                updateLikedHouses()
                updateLikedTaxis()
                updateLikedParties()
                showEmptyAnimation(.house)
                tableView.reloadData()
                Loader.stop()
                timer?.invalidate()
                timer = nil
            }
            
        })
        
        timer?.fire()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        title = SetLanguage.setLang(type: .wishlists)
        
        updateLikedHouses()
        updateLikedTaxis()
        updateLikedParties()
        
        showEmptyAnimation(selectedCategory)
        
        tableView.reloadData()
    }
    
    @IBAction func trashBtnPressed(_ sender: Any) {
        let vc = DeleteLikedsVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.deleteDelegate = self
        present(vc, animated: false)
    }
    
    @IBAction func segmentPressed(_ sender: Any) {
        if categoriesSegmen.selectedSegmentIndex == 0 {
            selectedCategory = .house
        } else if categoriesSegmen.selectedSegmentIndex == 1 {
            selectedCategory = .party
        } else {
            selectedCategory = .taxi
        }
        
        showEmptyAnimation(selectedCategory)
        tableView.reloadData()
    }
    
    //MARK: Functions
    
    private func showEmptyAnimation(_ type: ServiceType){
        switch type {
        case .house:
            showAnimation(likedHouses.isEmpty ? true : false)
        case .taxi:
            showAnimation(likedTaxiServices.isEmpty ? true : false)
        case .party:
            showAnimation(likedChildrenParties.isEmpty ? true : false)
        }
    }
    
    func setUpViews() {
        view.backgroundColor = .systemGray6
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikedCell.nib(), forCellReuseIdentifier: LikedCell.identifier)
        tableView.backgroundColor = .clear
        
        lottieView = .init(name: "animation_lmhzc44c")
        lottieView.frame = animationView.bounds
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        animationView.addSubview(lottieView)
        
        setupSegmen()
    }
    
    private func setupSegmen(){
        categoriesSegmen.removeAllSegments()
        categoriesSegmen.insertSegment(withTitle: SetLanguage.setLang(type: .houses), at: 0, animated: true)
        categoriesSegmen.insertSegment(withTitle: SetLanguage.setLang(type: .childrens), at: 1, animated: true)
        categoriesSegmen.insertSegment(withTitle: SetLanguage.setLang(type: .taxi), at: 2, animated: true)
        categoriesSegmen.selectedSegmentIndex = 0
    }
    
    /// Animate lottieView if not liked houses
    func showAnimation(_ shouldShow: Bool) {
        if shouldShow {
            tableView.isHidden = true
            lottieView.isHidden = false
            trashButton.isHidden = true
            lottieView.play()
        } else {
            lottieView.stop()
            lottieView.isHidden = true
            tableView.isHidden = false
            trashButton.isHidden = false
        }
    }
    
    private func updateLikedHouses(){
        likedHousesID = userDef.object(forKey: Keys.likedHouses) as? [Int] ?? []
        likedHouses = []
        
        for house in allHouses {
            if likedHousesID.contains(house.id) {
                likedHouses.append(house)
            }
        }
    }
    
    private func updateLikedParties(){
        likedPartiesIDs = userDef.object(forKey: Keys.likedParties) as? [Int] ?? []
        likedChildrenParties = []
        
        for party in allParties {
            if likedPartiesIDs.contains(party.id) {
                likedChildrenParties.append(party)
            }
        }
    }
   
    private func updateLikedTaxis(){
        likedTaxisIDs = userDef.object(forKey: Keys.likedTaxis) as? [Int] ?? []
        likedTaxiServices = []
        
        for taxi in allTaxis {
            if likedTaxisIDs.contains(taxi.id) {
                likedTaxiServices.append(taxi)
            }
        }
    }
    
    private func getAllHouses() {
        API.getAllHouses { [weak self] houses in
            guard let self = self else { return }
            guard let houses = houses else { return }

            serviceRespondCounter += 1
            
            allHouses = houses
            updateLikedHouses()
        }
    }
    
    private func getAllTaxiServices() {
        API.getAllTaxiServices { [weak self] taxis in
            guard let self = self else { return }
            guard let taxis = taxis else { return }
            
            serviceRespondCounter += 1
            
            allTaxis = taxis
            updateLikedTaxis()
        }
    }
    
    private func getAllParties() {
        API.getAllChildrenParties { [weak self] parties in
            guard let self = self else { return }
            guard let parties = parties else { return }
            
            serviceRespondCounter += 1
            
            allParties = parties
            updateLikedParties()
        }
    }
    
    func deleteAt(ind: Int) {
        switch selectedCategory {
        case .house:
            likedHouses.remove(at: ind)
            likedHousesID.remove(at: ind)
            UserDefaults.standard.set(likedHousesID, forKey: Keys.likedHouses)
        case .taxi:
            likedTaxiServices.remove(at: ind)
            likedTaxisIDs.remove(at: ind)
            UserDefaults.standard.set(likedTaxisIDs, forKey: Keys.likedTaxis)
        case .party:
            likedChildrenParties.remove(at: ind)
            likedPartiesIDs.remove(at: ind)
            UserDefaults.standard.set(likedPartiesIDs, forKey: Keys.likedParties)
        }
        showEmptyAnimation(selectedCategory)
        tableView.reloadData()
    }
    
    func moreInfoPressed(vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        vc.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UITableViewDataSource
extension LikedHousesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedCategory {
        case .house:
            return likedHouses.count
        case .taxi:
            return likedTaxiServices.count
        case .party:
            return likedChildrenParties.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikedCell.identifier, for: indexPath) as! LikedCell
        
        switch selectedCategory {
        case .house:
            cell.loadImage(url: likedHouses[indexPath.row].images[0])
            cell.nameLbl.text = likedHouses[indexPath.row].name
        case .taxi:
            cell.loadImage(url: likedTaxiServices[indexPath.row].carImages[0])
            cell.nameLbl.text = likedTaxiServices[indexPath.row].title
            
        case .party:
            cell.loadImage(url: likedChildrenParties[indexPath.row].images[0])
            cell.nameLbl.text = likedChildrenParties[indexPath.row].title
        }
        
        cell.contentView.backgroundColor = .clear
        cell.backView.backgroundColor = .white
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension LikedHousesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch selectedCategory {
        case .house:
            let selectedHouseID = likedHouses[indexPath.row].id
            let vc = HomeDetailVC()
            vc.getData(id: selectedHouseID)
            
            moreInfoPressed(vc: vc)
        case .taxi:
            let selectedTaxi = likedTaxiServices[indexPath.row]
            let vc = TaxiDetailVC()
            vc.setValues(taxi: selectedTaxi)
            
            moreInfoPressed(vc: vc)
        case .party:
            let selectedParty = likedChildrenParties[indexPath.row]
            let vc = ChildrensServiceDetailVC()
            vc.setValues(selectedParty)
            
            moreInfoPressed(vc: vc)
        }
        
//        moreInfoPressed(id: selectedHouse.id)
        
        
       
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: SetLanguage.setLang(type: .delete)) { (contextualAction, actionView, actionPerformer: (Bool) -> ()) in
            self.deleteAt(ind: indexPath.row)
            actionPerformer(true)
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

extension LikedHousesVC: DeleteLikedsDelegate {
    func deleteAllProducts() {
        switch selectedCategory {
        case .house:
            for _ in 0..<likedHouses.count { deleteAt(ind: 0) }
        case .taxi:
            for _ in 0..<likedTaxiServices.count { deleteAt(ind: 0) }
        case .party:
            for _ in 0..<likedChildrenParties.count { deleteAt(ind: 0) }
        }
    }
}
