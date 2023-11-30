//
//  AdditionalTVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit

protocol AdditionalDelegate: AnyObject {
    func showAllPressed()
}

class AdditionalTVC: UITableViewCell {
    
    static let identifier: String = String(describing: AdditionalTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var additionalFeaturesLbl: UILabel!
    
    @IBOutlet weak var showBtn: UIButton!
    
    @IBOutlet weak var tableViewConst: NSLayoutConstraint!
    
    static var addedFeatures = Array(repeating: false, count: 27)
    var features = [Entertainmentdatum]()
    weak var delegate: AdditionalDelegate?
    var imageHidden = false
    var isFilter = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    //MARK: @IBAction func
    
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
    
    //MARK: functions
    
    func updateCell(_ features: [Entertainmentdatum]){
        self.features = features
        tableView.reloadData()
    }
    
    func setUpViews() {
        showBtn.addBorder(size: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AditionalChildTVC.nib(), forCellReuseIdentifier: AditionalChildTVC.identifier)
        
        showBtn.setTitle(SetLanguage.setLang(type: .showAllElementsBtn), for: .normal)
        additionalFeaturesLbl.text = SetLanguage.setLang(type: .additionalFeatures)
        additionalFeaturesLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
    }
    
    func clearChanges(){
        AdditionalTVC.addedFeatures = Array(repeating: false, count: 27)
        tableView.reloadData()
    }
    
}

//MARK: UITableViewDataSource
extension AdditionalTVC: UITableViewDataSource {
    
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
            cell.update(isSelected: AdditionalTVC.addedFeatures[indexPath.row])
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension AdditionalTVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFilter {
            AdditionalTVC.addedFeatures[indexPath.row] = !AdditionalTVC.addedFeatures[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? AditionalChildTVC {
                cell.update(isSelected: AdditionalTVC.addedFeatures[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
