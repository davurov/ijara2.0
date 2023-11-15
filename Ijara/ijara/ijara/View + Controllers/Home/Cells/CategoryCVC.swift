//
//  CategoryCVC.swift
//  ijara
//
//  Created by Muslim on 24/08/23.
//

import UIKit

class CategoryCVC: UICollectionViewCell {

    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let identifier: String = String(describing: CategoryCVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell(){
        categoryNameLbl.textAlignment = .center
        categoryNameLbl.textColor = AppColors.mainColor
        categoryNameLbl.font = .systemFont(ofSize: 15, weight: .bold)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderColor = AppColors.mainColor.cgColor
        containerView.layer.borderWidth = 2
        containerView.backgroundColor = .clear
    }
    
}
