//
//  NewsImagesTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 25/12/23.
//

import UIKit

class NewsImagesTVC: UITableViewCell {
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var img3: UIImageView!
    
    static let identifire = String(describing: NewsImagesTVC.self)
    static func nib() -> UINib { UINib(nibName: identifire, bundle: nil) }
    
    let screenWidth = UIScreen.main.bounds.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews(){
        
        for img in [img1, img2, img3] {
            img?.translatesAutoresizingMaskIntoConstraints = false
            img?.clipsToBounds = true
        }
        
        NSLayoutConstraint.activate([
            img1.widthAnchor.constraint(equalToConstant: screenWidth-30),
            img1.heightAnchor.constraint(equalToConstant: (screenWidth-30)/2),
            
            img2.widthAnchor.constraint(equalToConstant: (screenWidth-45)/2),
            img2.heightAnchor.constraint(equalToConstant: ((screenWidth-45)/3)),
            
            img3.widthAnchor.constraint(equalToConstant: (screenWidth-45)/2),
            img3.heightAnchor.constraint(equalToConstant: ((screenWidth-45)/3)),
        ])
        
        img1.layer.cornerRadius = 25
        img2.layer.cornerRadius = 25
        img3.layer.cornerRadius = 25
        
    }
    
}
