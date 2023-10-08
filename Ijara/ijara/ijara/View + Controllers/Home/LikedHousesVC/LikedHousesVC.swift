//
//  LikedHousesVC.swift
//  ijara
//
//  Created by Abduraxmon on 12/09/23.
//

import UIKit
import Lottie

class LikedHousesVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: UIView!
    
    var likedHousesID = [String]() {
        didSet {
            showAnimation()
        }
    }
    var houseDM = [HouseDM]()
    var likedHouses = [HouseDM]()
    var lottieView: LottieAnimationView?
    var selected = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setUpViews()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedHousesID = UserDefaults.standard.array(forKey: Keys.likedHouses) as! [String]
        getById()
        showAnimation()
    }
    
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LikedCell.nib(), forCellReuseIdentifier: LikedCell.identifier)
    }
    
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
            return}
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
        if let savedHouse = UserDefaults.standard.object(forKey: Keys.houseData) as? Data {
            let decoder = JSONDecoder()
            if let houses = try? decoder.decode([HouseDM].self , from: savedHouse) {
                houseDM = houses
            }
        }
    }
    
    func getById() {
        likedHouses = []
        for i in houseDM {
            if likedHousesID.contains("\(i.id)") {
                likedHouses.append(i)
            }
        }
        tableView.reloadData()
    }
    
    func deleteAt(ind: Int) {
        likedHouses.remove(at: ind)
        likedHousesID.remove(at: ind)
        UserDefaults.standard.set(likedHousesID, forKey: Keys.likedHouses)
    }
    
    func moreInfoPressed(id: String, images: [String]) {
        let vc = HomeDetailVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        vc.images = images
        vc.id = id
        vc.price.weekday = Int(likedHouses[selected].weekends.replacingOccurrences(of: " ", with: "")) ?? 0
        vc.price.wrking = Int(likedHouses[selected].workingdays.replacingOccurrences(of: " ", with: "")) ?? 0
    }
    
}

extension LikedHousesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedHouses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikedCell.identifier, for: indexPath) as! LikedCell
        
        cell.loadImage(url: likedHouses[indexPath.row].images[0])
        cell.nameLbl.text = likedHouses[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        moreInfoPressed(id: "\(likedHouses[indexPath.row].id)", images: likedHouses[indexPath.row].images)
        selected = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, actionView, actionPerformer: (Bool) -> ()) in
            self.deleteAt(ind: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            actionPerformer(true)
        }
        
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemPink
        
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
