//
//  AditionalChildTVC.swift
//  ijara
//
//  Created by Abduraxmon on 19/09/23.
//

import UIKit

class AditionalChildTVC: UITableViewCell {
    
    static let identifier: String = String(describing: AditionalChildTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var additionalImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var indicatorImg: UIImageView!
    
    func update(isSelected: Bool) {
        if isSelected {
            indicatorImg.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            indicatorImg.image = UIImage(systemName: "square")
        }
    }
    
    func loadImage(url: String) {
        additionalImg.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
    }
}
