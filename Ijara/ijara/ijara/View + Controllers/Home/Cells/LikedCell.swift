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
    
    @IBOutlet weak var likedDateLbl: UILabel!
    
    static let identifier: String = String(describing: LikedCell.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .white
        backView.backgroundColor = .white
        contentView.addShadowCustom(offset: CGSize(width: 3, height: 3), color: AppColors.mainColor.cgColor, radius: 3, opacity: 0.5)
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .clear
    }
    
    func loadImage(url: String, likedDate: String) {
        houseImage.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
        likedDateLbl.text = likedDate
    }
    
}
