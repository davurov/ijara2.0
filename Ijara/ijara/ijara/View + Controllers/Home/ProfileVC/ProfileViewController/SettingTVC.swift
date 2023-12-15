//
//  SettingTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 14/12/23.
//

import UIKit

class SettingTVC: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var settingNameLbl: UILabel!
    
    
    static let identifier = String(describing: SettingTVC.self)
    static func nib() -> UINib { UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell(icon: UIImage?, settingName: String){
        self.icon.image = icon
        settingNameLbl.text = settingName
    }
    
}
