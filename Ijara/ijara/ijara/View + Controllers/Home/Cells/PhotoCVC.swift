//
//  PhotoCVC.swift
//  ijara
//
//  Created by Abduraxmon on 04/09/23.
//

import UIKit

class PhotoCVC: UICollectionViewCell {
    
    
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var imageCont: UIView!
    
    var isExpanded = false
    
    static let identifier: String = String(describing: PhotoCVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    override func prepareForReuse() {
        houseImage.sd_cancelCurrentImageLoad()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadImage(url: String) {
        houseImage.sd_setImage(with: URL(string: base_URL + url), placeholderImage: UIImage(named: "1"))
    }
    
    func toggleSize() {
        isExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            self.houseImage.transform = self.isExpanded ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
            self.layoutIfNeeded()
        }
    }
    
}
