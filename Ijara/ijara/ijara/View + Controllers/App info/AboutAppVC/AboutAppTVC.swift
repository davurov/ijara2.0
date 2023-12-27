//
//  AboutAppTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 24/11/23.
//

import UIKit

class AboutAppTVC: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    static let identifire = String(describing: AboutAppTVC.self)
    static func nib() -> UINib { UINib(nibName: identifire, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.backgroundColor = .clear
        }
    }
    
     func updateCell(_ title: String, description: String){
        titleLbl.text = title
        descriptionLbl.text = description
    }
    
    private func setupViews(){
        contentView.backgroundColor = .clear
        descriptionLbl.numberOfLines = 0
    }
    
}
