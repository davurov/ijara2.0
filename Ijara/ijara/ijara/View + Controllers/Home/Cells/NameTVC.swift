//
//  NameTVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit

class NameTVC: UITableViewCell {
    
    static let identifier: String = String(describing: NameTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var starLbl: UILabel!
    @IBOutlet weak var viewsLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    let nameLbl2 = UILabel()
    let starImg = UIImageView()
    let starLbl2 = UILabel()
    let viewsLbl2 = UILabel()
    let locationLbl2 = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    func updateCell(_ name: String, _ location: String,  _ star: String, _ views: String){
        nameLbl2.text = name
        locationLbl2.text = location
        starLbl2.text = star
        viewsLbl2.text = views
        setupViews()
    }
    
    func setupViews(){
        for i in [nameLbl, starLbl, viewsLbl, locationLbl] {
            i!.isHidden = true
        }
        
        for j in [nameLbl2, starLbl2, viewsLbl2, locationLbl2, starImg] {
            contentView.addSubview(j)
            j.translatesAutoresizingMaskIntoConstraints = false
        }
        
        nameLbl2.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        
        starImg.image = UIImage(systemName: "star.fill")
        starImg.tintColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        locationLbl2.font = .systemFont(ofSize: 15)
        locationLbl2.textColor = .lightGray
        
        NSLayoutConstraint.activate([
            nameLbl2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            nameLbl2.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            starImg.leftAnchor.constraint(equalTo: nameLbl2.leftAnchor, constant: 0),
            starImg.topAnchor.constraint(equalTo: nameLbl2.bottomAnchor, constant: 5),
            
            starLbl2.leftAnchor.constraint(equalTo: starImg.rightAnchor, constant: 3),
            starLbl2.topAnchor.constraint(equalTo: nameLbl2.bottomAnchor, constant: 5),
            
            viewsLbl2.leftAnchor.constraint(equalTo: starLbl2.rightAnchor, constant: 10),
            viewsLbl2.topAnchor.constraint(equalTo: starLbl2.topAnchor, constant: 0),
            
            locationLbl2.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            locationLbl2.topAnchor.constraint(equalTo: starLbl2.bottomAnchor, constant: 10),
            locationLbl2.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5)
        ])
        
        locationLbl2.numberOfLines = 0

    }
    
}
