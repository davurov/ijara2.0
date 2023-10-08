//
//  PickerTVC.swift
//  ijara
//
//  Created by Abduraxmon on 26/09/23.
//

import UIKit

class PickerTVC: UITableViewCell {
    
    static let identifier: String = String(describing: PickerTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
