//
//  LikedCell.swift
//  ijara
//
//  Created by Abduraxmon on 13/09/23.
//

import UIKit

class LikedCell: UITableViewCell {
    
    
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    static let identifier: String = String(describing: LikedCell.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .clear
    }
    
    func loadImage(url: String) {
        houseImage.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
    }
    
}
