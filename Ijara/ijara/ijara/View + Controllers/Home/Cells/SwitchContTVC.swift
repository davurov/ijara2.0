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
    
    @IBOutlet weak var additionalLbl: UILabel! {
        didSet {
            additionalLbl.text = SetLanguage.setLang(type: .additional)
            additionalLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        }
    }
    
    @IBOutlet weak var alcoholLbl: UILabel! {
        didSet {
            alcoholLbl.text = SetLanguage.setLang(type: .alcohol)
        }
    }
    
    @IBOutlet weak var verifiedLbl: UILabel! {
        didSet {
            verifiedLbl.text = SetLanguage.setLang(type: .verified)
        }
    }
    
   static var selectedParametrs = (alcohol: false, verified: false)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func alcoholPressed(_ sender: Any) {
        alcoholSwitch.isOn = !alcoholSwitch.isOn
        SwitchContTVC.selectedParametrs.alcohol = alcoholSwitch.isOn
    }
    
    @IBAction func verifiedPressed(_ sender: Any) {
        verifiedSwitch.isOn = !verifiedSwitch.isOn
        SwitchContTVC.selectedParametrs.verified = verifiedSwitch.isOn
    }
    
    func clearChanges(){
        alcoholSwitch.isOn = false
        verifiedSwitch.isOn = false
    }
    
}
