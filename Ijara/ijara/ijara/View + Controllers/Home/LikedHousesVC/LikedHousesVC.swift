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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: UIView!
    
    //MARK: Variables
    var likedHousesID = [Int]()
//    {
//        didSet {
////            showAnimation()
//        }
//    }
//    var houseDM = [HouseDM]()
    var likedHouses = [CountryhouseData]() {
        didSet {
            tableView.reloadData()
        }
    }
    var lottieView: LottieAnimationView?
    
    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        wishlistsLbl.text = SetLanguage.setLang(type: .wishlists)
        setUpViews()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedHousesID = UserDefaults.standard.array(forKey: Keys.likedHouses) as? [Int] ?? []
        getData()
        showAnimation()
        tableView.reloadData()
     }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: Functions
    
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikedCell.nib(), forCellReuseIdentifier: LikedCell.identifier)
    }
    
    /// Animate lottieView if not liked houses
    func showAnimation() {
        guard likedHousesID.isEmpty else {
            lottieView?.stop()
            tableView.isHidden = false
            return
        }
        guard lottieView == nil else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.isHidden = true
            }
            lottieView!.play()
            return
        }
        tableView.isHidden = true
        lottieView = .init(name: "animation_lmhzc44c")
        lottieView!.frame = animationView.bounds
        lottieView!.contentMode = .scaleAspectFit
        lottieView!.loopMode = .loop
        lottieView!.animationSpeed = 0.5
        animationView.addSubview(lottieView!)
        lottieView!.play()
    }
    
    func getData() {
        Loader.start()
        likedHouses = []
        for id in likedHousesID {
            API.getDetailDataByID(id: id) { villa in
                guard let likedHouse = villa else { return }
                self.likedHouses.append(likedHouse)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            self.tableView.reloadData()
            Loader.stop()
        }
        
//        API.getProducts { houses in
//            Loader.stop()
//            guard let houses = houses else { return }
//            self.houseDM = houses
//            self.tableView.reloadData()
//        }
        
//        if let savedHouse = UserDefaults.standard.object(forKey: Keys.houseData) as? Data {
//            let decoder = JSONDecoder()
//            if let houses = try? decoder.decode([HouseDM].self , from: savedHouse) {
//                houseDM = houses
//            }
//        }
    }
    
//    func getById() {
//        likedHouses = []
//        for i in houseDM {
//            if likedHousesID.contains("\(i.id)") {
//                likedHouses.append(i)
//            }
//        }
//        tableView.reloadData()
//    }
    
    func deleteAt(ind: Int) {
        likedHouses.remove(at: ind)
        likedHousesID.remove(at: ind)
        UserDefaults.standard.set(likedHousesID, forKey: Keys.likedHouses)
    }
    
    func moreInfoPressed(id: Int, images: [String]) {
        let vc = HomeDetailVC()
        vc.id = id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
//        vc.images = images
//        vc.id = Int(id) ?? 0
//        vc.price.weekday = Int(likedHouses[selected].weekends.replacingOccurrences(of: " ", with: "")) ?? 0
//        vc.price.wrking = Int(likedHouses[selected].workingdays.replacingOccurrences(of: " ", with: "")) ?? 0
    }
    
}

//MARK: UITableViewDataSource
extension LikedHousesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedHouses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikedCell.identifier, for: indexPath) as! LikedCell
        
        cell.loadImage(url: likedHouses[indexPath.row].images[0])
        cell.nameLbl.text = likedHouses[indexPath.row].name
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension LikedHousesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedHouse = likedHouses[indexPath.row]
        moreInfoPressed(id: selectedHouse.id, images: selectedHouse.images)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: SetLanguage.setLang(type: .delete)) { (contextualAction, actionView, actionPerformer: (Bool) -> ()) in
            self.deleteAt(ind: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
