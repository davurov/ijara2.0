//
//  PhotoCVC.swift
//  ijara
//
//  Created by Abduraxmon on 04/09/23.
//

import UIKit

class PhotoCVC: UICollectionViewCell {
    
    
    @IBOutlet weak var houseImage: UIImageView!
    
    static let identifier: String = String(describing: PhotoCVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
