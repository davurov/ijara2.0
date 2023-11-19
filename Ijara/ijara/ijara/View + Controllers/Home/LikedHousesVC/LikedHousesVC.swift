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
     }
    
    //MARK: Functions
    
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikedCell.nib(), forCellReuseIdentifier: LikedCell.identifier)
        tableView.backgroundColor = .clear
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
        
        guard var lottieView = lottieView else { return }
        
        tableView.isHidden = true
        lottieView = .init(name: "animation_lmhzc44c")
        lottieView.frame = animationView.bounds
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.5
        animationView.addSubview(lottieView)
        lottieView.play()
    }
    
    func getData() {
        Loader.start()
        likedHouses = []
        
        var counterOfResponses = 0
        
        if likedHousesID.count == 0 {
            self.tableView.reloadData()
            Loader.stop()
        }
        
        for id in likedHousesID {
            API.getDetailDataByID(id: id) { villa in
                counterOfResponses += 1
                guard let likedHouse = villa else { return }
                
                self.likedHouses.append(likedHouse)
                
                if counterOfResponses == self.likedHousesID.count {
                    self.tableView.reloadData()
                    Loader.stop()
                }
                
            }
        }
    }
    
    func deleteAt(ind: Int) {
        likedHouses.remove(at: ind)
        likedHousesID.remove(at: ind)
        UserDefaults.standard.set(likedHousesID, forKey: Keys.likedHouses)
        tableView.reloadData()
    }
    
    func moreInfoPressed(id: Int) {
        let vc = HomeDetailVC()
        vc.getData(id: id)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
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
        cell.backgroundColor = .clear
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension LikedHousesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedHouse = likedHouses[indexPath.row]
        moreInfoPressed(id: selectedHouse.id)
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
