//
//  PhotoCVC.swift
//  ijara
//
//  Created by Abduraxmon on 04/09/23.
//

import UIKit
import SDWebImage

class PhotoCVC: UICollectionViewCell {
    
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var imageCont: UIView!
    
    var isExpanded = false
    var isWithRadius = false
    
    static let identifier: String = String(describing: PhotoCVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if isWithRadius {
            imageCont.layer.cornerRadius = 10
            imageCont.clipsToBounds = true
            
            houseImage.layer.cornerRadius = 10
            houseImage.clipsToBounds = true
        }
    }
    
    func loadImage(url: String) {
        let url = URL(string: base_URL + url)
        guard let url = url else { return }
        
        let options: SDWebImageOptions = [.highPriority, .continueInBackground]
        
        houseImage.sd_setImage(with: url, placeholderImage: UIImage(named: "homeImg"), options: options)
    }
    
    func giveRadius(_ radius: CGFloat){
        imageCont.layer.cornerRadius = radius
        imageCont.clipsToBounds = true
        
        houseImage.layer.cornerRadius = radius
        houseImage.clipsToBounds = true
    }
    
    func toggleSize() {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.houseImage.transform = self.isExpanded ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
            self.layoutIfNeeded()
        }
    }
    
}



