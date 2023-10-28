//
//  AdditionalVC.swift
//  ijara
//
//  Created by Abduraxmon on 25/09/23.
//

import UIKit

class AdditionalVC: UIViewController {

    @IBOutlet weak var offersLbl: UILabel! {
        didSet {
            offersLbl.text = SetLanguage.setLang(type: .additionaFeaturesOffers)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var features = [Entertainmentdatum]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUptableView()
    }
    
    func setUptableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AditionalChildTVC.nib(), forCellReuseIdentifier: AditionalChildTVC.identifier)
    }

}
extension AdditionalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AditionalChildTVC.identifier, for: indexPath) as! AditionalChildTVC
        cell.loadImage(url: features[indexPath.row].image)
        cell.nameLbl.text = features[indexPath.row].name
        cell.indicatorImg.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
