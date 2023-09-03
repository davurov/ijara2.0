//
//  TopItemCVC.swift
//  ijara
//
//  Created by Muslim on 28/08/23.
//

import UIKit

class TopItemCVC: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    static let identifier: String = String(describing: TopItemCVC.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 16
        
        containerView.layer.masksToBounds = false

        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOffset = CGSize(width: 6, height: 6)
        containerView.layer.shadowOpacity = 0.6
        
    }
    
}
