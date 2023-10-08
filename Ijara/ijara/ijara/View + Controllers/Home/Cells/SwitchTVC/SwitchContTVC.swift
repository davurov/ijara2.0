//
//  SwitchContTVC.swift
//  ijara
//
//  Created by Abduraxmon on 26/09/23.
//

import UIKit

class SwitchContTVC: UITableViewCell {
    
    static let identifier: String = String(describing: SwitchContTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var alcoholSwitch: UISwitch!
    @IBOutlet weak var verifiedSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func alcoholPressed(_ sender: Any) {
        alcoholSwitch.isOn = !alcoholSwitch.isOn
    }
    
    @IBAction func verifiedPressed(_ sender: Any) {
        verifiedSwitch.isOn = !verifiedSwitch.isOn
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
