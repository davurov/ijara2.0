//
//  AllHousesCVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 12/12/23.
//

import UIKit

class AllHousesCVC: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var houseName: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    
    static let identifier = String(describing: AllHousesCVC.self)
    static func nib() -> UINib { UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        backView.addBorder(size: 1)
        backView.layer.cornerRadius = 10
        backView.clipsToBounds = true
    }
    
    func updateCell(_ house: CountryhouseData){
        let url = URL(string: base_URL + (house.images.first ?? ""))
        img.sd_setImage(with: url)
        
        houseName.text = house.name
        locationLbl.text = house.province
    }
    
}
