//
//  FiltrVC.swift
//  ijara
//
//  Created by Abduraxmon on 25/09/23.
//

import UIKit

class FiltrVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showView: UIView!
    
    var priceRange = [Int]()
    var enterData = [Entertainmentdatum]()
    var houseDM = [HouseDM]() {
        didSet {
            priceRange = houseDM.map {Int($0.workingdays.replacingOccurrences(of: " ", with: "")) ?? 0}
        }
    }
    var additionalHeight: CGFloat = 340
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getData()
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PriceRangeTVC.nib(), forCellReuseIdentifier: PriceRangeTVC.identifier)
        tableView.register(RuleFiltrTVC.nib(), forCellReuseIdentifier: RuleFiltrTVC.identifier)
        tableView.register(AdditionalTVC.nib(), forCellReuseIdentifier: AdditionalTVC.identifier)
        tableView.register(SwitchContTVC.nib(), forCellReuseIdentifier: SwitchContTVC.identifier)
        tableView.register(BedsTVC.nib(), forCellReuseIdentifier: BedsTVC.identifier)
        
        showView.addShadowByHand(offset: CGSize(width: 0, height: 0), color: AppColors.customBlack.cgColor, radius: 5, opacity: 0.2)
        showView.layer.cornerRadius = 20
        showView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    func getData() {
        API.getEntertainmentData(lang: "uz") { data in
            if let data = data {
                self.enterData = data
                self.tableView.reloadData()
            }
        }
    }

}

extension FiltrVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PriceRangeTVC.identifier, for: indexPath) as! PriceRangeTVC
            
            cell.setupPriceRange(priceRange)
            
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RuleFiltrTVC.identifier, for: indexPath) as! RuleFiltrTVC
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalTVC.identifier, for: indexPath) as! AdditionalTVC
            cell.delegate = self
            cell.features = enterData
            cell.imageHidden = true
            cell.isFilter = true
            cell.tableView.reloadData()
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchContTVC.identifier, for: indexPath) as! SwitchContTVC

            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BedsTVC.identifier, for: indexPath) as! BedsTVC
            
            return cell
        }
    
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 230
        case 1: return 260
        case 2: return additionalHeight
        case 3: return 150
        case 4: return 130
        default: return 160
        }
    }
}
extension FiltrVC: AdditionalDelegate, AddFeaturesDelegate {
    //TODO: - DEAL WITH FILTERED OBJECTS
    func featureSelected(id: Int) {

    }
    
    func showAllPressed() {
        if additionalHeight == 340 {
            additionalHeight = CGFloat(40 * enterData.count) + 140
        } else {
            additionalHeight = 340
        }
        tableView.reloadData()
    }
}
