//
//  HomeCVC.swift
//  ijara
//
//  Created by Muslim on 28/08/23.
//

import UIKit

class HomeCVC: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pirceLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var imageCont: UIView!
    @IBOutlet weak var verifiedImg: UIImageView!
    
    @IBOutlet weak var alcoholImg: UIImageView!
    
    @IBOutlet weak var onlyFamilyImg: UIImageView!
    @IBOutlet weak var womenImg: UIImageView!
    @IBOutlet weak var menImg: UIImageView!
    @IBOutlet weak var mixImg: UIImageView!
    
    /// Home Cell Identifier
    static let identifier: String = String(describing: HomeCVC.self)
    
    func isVerified(v: Bool, alco: Bool, typeId: [Int]) {
        verifiedImg.isHidden = !v
        alcoholImg.image = UIImage(named: "\(alco)")
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        imageCont.layer.cornerRadius = 10
        imageCont.clipsToBounds = true
    }

}
