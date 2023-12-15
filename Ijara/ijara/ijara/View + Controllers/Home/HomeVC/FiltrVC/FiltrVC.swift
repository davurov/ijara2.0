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
    
    @IBOutlet weak var clearAllBtn: UIButton! {
        didSet {
            clearAllBtn.setTitle(SetLanguage.setLang(type: .clearAll), for: .normal)
        }
    }
    @IBOutlet weak var showBtn: UIButton!{
        didSet {
            showBtn.setTitle(SetLanguage.setLang(type: .show), for: .normal)
        }
    }
    
    var priceRange: (minPrice: Int, maxPrice: Int) = (500000,15000000)
    var enterData = [Entertainmentdatum]()
    var additionalHeight: CGFloat = 340
    
    var isClearAllPressed = false
    weak var filtrDelegate: FiltredDelegate?
    
    //MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getData()
    }
    
    @IBAction func clearAllPressed(_ sender: Any) {
        isClearAllPressed = true
        tableView.reloadData()
    }
    
    @IBAction func showPressed(_ sender: Any) {
        
        var guestType = [Int]()
        var additionalFetures = [Int]()
        var isAllowedAlcohol = false
        var isVerified = false
        var numberOfPeople: Int?
        
        for rule in RuleFiltrTVC.btnPressed.enumerated() where rule.element == true {
            guestType.append(rule.offset+1)
        }
        
        for additional in AdditionalTVC.addedFeatures.enumerated() where additional.element == true {
            additionalFetures.append(additional.offset+1)
        }
        
        isAllowedAlcohol = SwitchContTVC.selectedParametrs.alcohol
        isVerified = SwitchContTVC.selectedParametrs.verified
        
        if let beds = BedsTVC.numberOfPeople {
            numberOfPeople = beds
        }
        
        // give selected parametrs to homeVC
        
        guard let filtrDelegate = filtrDelegate else { return }
        
        filtrDelegate.filtrData(
            minPrice: NewPriceRangeTVC.minPriceFiltr,
            maxPrice: NewPriceRangeTVC.maxPriceFiltr,
            guestType: guestType,
            additionalFetures: additionalFetures,
            isAllowedAlcohol: isAllowedAlcohol,
            isVerified: isVerified,
            numberOfPeople: numberOfPeople
        )
        
        isClearAllPressed = true
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewPriceRangeTVC.self, forCellReuseIdentifier: NewPriceRangeTVC.identifier)
        tableView.register(RuleFiltrTVC.nib(), forCellReuseIdentifier: RuleFiltrTVC.identifier)
        tableView.register(AdditionalTVC.nib(), forCellReuseIdentifier: AdditionalTVC.identifier)
        tableView.register(SwitchContTVC.nib(), forCellReuseIdentifier: SwitchContTVC.identifier)
        tableView.register(BedsTVC.nib(), forCellReuseIdentifier: BedsTVC.identifier)
        
        showView.layer.shadowColor = AppColors.customBlack.cgColor
        showView.layer.shadowOpacity = 0.3
        showView.layer.shadowRadius = 5
        showView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        showView.layer.cornerRadius = 20
        showView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        clearAllBtn.titleLabel?.numberOfLines = 0
    }
    
    func getData() {
        API.getEntertainmentData() { data in
            if let data = data {
                self.enterData = data
                self.tableView.reloadData()
            }
        }
    }

}

//MARK: UITableViewDataSource
extension FiltrVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewPriceRangeTVC.identifier, for: indexPath) as! NewPriceRangeTVC

            cell.handleSlider(initMinPrice: priceRange.minPrice, initMaxPrice: priceRange.maxPrice)
            
            if isClearAllPressed {
                cell.clearChanged()
            }
            
            return cell
        } else if indexPath.row == 1 {
            /// This cell to choose guest type
            let guestCell = tableView.dequeueReusableCell(withIdentifier: RuleFiltrTVC.identifier, for: indexPath) as! RuleFiltrTVC
            
            if isClearAllPressed {
                guestCell.clearChanges()
            }
            
            return guestCell
        } else if indexPath.row == 2 {
            let additionalCell = tableView.dequeueReusableCell(withIdentifier: AdditionalTVC.identifier, for: indexPath) as! AdditionalTVC
            additionalCell.delegate = self
            additionalCell.features = enterData
            additionalCell.imageHidden = true
            additionalCell.isFilter = true
            additionalCell.tableView.reloadData()
            
            if isClearAllPressed {
                additionalCell.clearChanges()
            }
            
            return additionalCell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchContTVC.identifier, for: indexPath) as! SwitchContTVC
            
            if isClearAllPressed {
                cell.clearChanges()
            }
            
            return cell
        } else if indexPath.row == 4 {
            let bedCell = tableView.dequeueReusableCell(withIdentifier: BedsTVC.identifier, for: indexPath) as! BedsTVC
            
            if isClearAllPressed {
                bedCell.clearChanges()
            }
            
            return bedCell
        }
    
        return UITableViewCell()
    }
}

//MARK: UITableViewDelegate
extension FiltrVC: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            isClearAllPressed = false
        }
    }
    
}

extension FiltrVC: AdditionalDelegate {
    func openOwnerInfoVC() {
        //
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
