//
//  RulesCVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit

class RulesCVC: UICollectionViewCell {
    
    static let identifier: String = String(describing: RulesCVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    
    @IBOutlet weak var ruleImg: UIImageView!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var ruleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contView.addBorder(size: 1)
    }
    
    func loadImage(url: String) {
        ruleImg.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
    }

}
