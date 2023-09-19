//
//  AdditionalTVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit

class AdditionalTVC: UITableViewCell {
    
    static let identifier: String = String(describing: AdditionalTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showBtn: UIButton!
    
    var features = [Entertainmentdatum]()
    
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
        
    }
    
}

extension AdditionalTVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AditionalChildTVC.identifier, for: indexPath) as! AditionalChildTVC
        
//        cell.nameLbl.text = features[indexPath.row].name
//        cell.loadImage(url: features[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
