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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(url: String) {
        additionalImg.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
    }
}
