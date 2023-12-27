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
        
        backView.layer.cornerRadius = 10
        
        backView.layer.shadowColor = UIColor.lightGray.cgColor
        backView.layer.shadowRadius = 6
        backView.layer.shadowOffset = CGSize(width: 6, height: 6)
        backView.layer.shadowOpacity = 0.3
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.backgroundColor = .systemGray6
        }
    }
    
    func loadImage(url: String) {
        houseImage.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
    }
    
}
