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
    @IBOutlet weak var innirPool: UIImageView!
    @IBOutlet weak var outerPool: UIImageView!
    
    /// Home Cell Identifier
    static let identifier: String = String(describing: HomeCVC.self)
    
    func isVerified(v: Bool, alco: Bool, typeId: [Companylist], pool: [Swimmingpool]) {
        
        verifiedImg.isHidden = !v
        alcoholImg.image = UIImage(named: "\(alco)")
        
        var compId = [Int]()
        
        for i in typeId {
            compId.append(i.id)
        }
        
        
        for i in 1...4 {
            if compId.contains(i) {
                switch i {
                case 1: onlyFamilyImg.isHidden = false
                case 2: womenImg.isHidden = false
                case 3: menImg.isHidden = false
                case 4: mixImg.isHidden = false
                default: break
                }
            } else {
                switch i {
                case 1: onlyFamilyImg.isHidden = true
                case 2: womenImg.isHidden = true
                case 3: menImg.isHidden = true
                case 4: mixImg.isHidden = true
                default: break
                }
            }
        }
        
        if pool.isEmpty {
            innirPool.isHidden = true
            outerPool.isHidden = true
        } else if pool.count == 1 {
            if pool[0].nsme == "Yozgi" {
                outerPool.isHidden = false
                innirPool.isHidden = true
            } else {
                innirPool.isHidden = false
                outerPool.isHidden = true
            }
        } else {
            innirPool.isHidden = false
            outerPool.isHidden = false
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        imageCont.layer.cornerRadius = 10
        imageCont.clipsToBounds = true
    }
    
}
