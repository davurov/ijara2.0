//
//  AdditionalTVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit

protocol AdditionalDelegate {
    func showAllPressed()
}
protocol AddFeaturesDelegate {
    func featureSelected(id: Int)
}


class AdditionalTVC: UITableViewCell {
    
    static let identifier: String = String(describing: AdditionalTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showBtn: UIButton! {
        didSet {
            showBtn.setTitle(SetLanguage.setLang(type: .showAllElementsBtn), for: .normal)
        }
    }
    @IBOutlet weak var tableViewConst: NSLayoutConstraint!
    
    @IBOutlet weak var additionalFeaturesLbl: UILabel! {
        didSet {
            additionalFeaturesLbl.text = SetLanguage.setLang(type: .additionalFeatures)
        }
    }
    
    var addedFeatures = Array(repeating: false, count: 27)
    var features = [Entertainmentdatum]()
    var delegate: AdditionalDelegate?
    var selectDelegete: AddFeaturesDelegate?
    var imageHidden = false
    var isFilter = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func setUpViews() {
        showBtn.addBorder(size: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AditionalChildTVC.nib(), forCellReuseIdentifier: AditionalChildTVC.identifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func showPressed(_ sender: Any) {
        delegate?.showAllPressed()
        if isFilter {
            if tableViewConst.constant == 200 {
                tableViewConst.constant = CGFloat(40 * features.count)
            } else {
                tableViewConst.constant = 200
            }
        }
    }
    
}

extension AdditionalTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AditionalChildTVC.identifier, for: indexPath) as! AditionalChildTVC
        
        cell.nameLbl.text = features[indexPath.row].name
        cell.additionalImg.isHidden = imageHidden
        cell.indicatorImg.isHidden = !imageHidden
        if !imageHidden {
            cell.loadImage(url: features[indexPath.row].image)
        } else {
            cell.update(isSelected: addedFeatures[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFilter {
            addedFeatures[indexPath.row] = !addedFeatures[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? AditionalChildTVC {
                cell.update(isSelected: addedFeatures[indexPath.row])
            }
            selectDelegete?.featureSelected(id: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
