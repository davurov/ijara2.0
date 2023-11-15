//
//  NameTVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit

class NameTVC: UITableViewCell {
    
    static let identifier: String = String(describing: NameTVC.self)
    
    let nameLbl = UILabel()
    let starImg = UIImageView()
    let starLbl = UILabel()
    let viewsLbl = UILabel()
    let locationLbl = UILabel()

    func updateCell(_ name: String, _ location: String,  _ star: String, _ views: String){
        nameLbl.text = name
        locationLbl.text = location
        starLbl.text = star
        viewsLbl.text = views
        setupViews()
    }
    
    func setupViews(){
        
        for j in [nameLbl, starLbl, viewsLbl, locationLbl, starImg] {
            contentView.addSubview(j)
            j.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        
        starImg.image = UIImage(systemName: "star.fill")
        starImg.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        locationLbl.font = .systemFont(ofSize: 15)
        locationLbl.textColor = .lightGray
        
        NSLayoutConstraint.activate([
            nameLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            nameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            starImg.leftAnchor.constraint(equalTo: nameLbl.leftAnchor, constant: 0),
            starImg.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 5),
            
            starLbl.leftAnchor.constraint(equalTo: starImg.rightAnchor, constant: 3),
            starLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 5),
            
            viewsLbl.leftAnchor.constraint(equalTo: starLbl.rightAnchor, constant: 10),
            viewsLbl.topAnchor.constraint(equalTo: starLbl.topAnchor, constant: 0),
            
            locationLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            locationLbl.topAnchor.constraint(equalTo: starLbl.bottomAnchor, constant: 10),
            locationLbl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5)
        ])
        
        locationLbl.numberOfLines = 0
    }
    
}
