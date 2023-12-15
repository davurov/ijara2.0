//
//  LikedCell.swift
//  ijara
//
//  Created by Abduraxmon on 13/09/23.
//

import UIKit

class LikedCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
        
    static let identifier: String = String(describing: LikedCell.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
        backView.backgroundColor = .white
        backView.layer.shadowColor = AppColors.mainColor.cgColor
        backView.layer.shadowOffset = CGSize(width: 5, height: 5)
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowRadius = 5
        
        backView.layer.cornerRadius = 10
    }
    
    func loadImage(url: String) {
        houseImage.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
    }
    
}
