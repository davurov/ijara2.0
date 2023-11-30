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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
     func updateCell(_ title: String, description: String){
        titleLbl.text = title
        descriptionLbl.text = description
    }
    
    private func setupViews(){
        contentView.backgroundColor = .clear
        
        titleLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        descriptionLbl.font = .systemFont(ofSize: 17, weight: .medium)
        descriptionLbl.numberOfLines = 0
    }
    
}
