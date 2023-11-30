//
//  InfoTVC.swift
//  ijara
//
//  Created by Abduraxmon on 19/09/23.
//

import UIKit

class InfoTVC: UITableViewCell {
    
    static let identifier: String = String(describing: InfoTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var numberOfPeaople: UILabel!
    @IBOutlet weak var numberOfBedrooms: UILabel!
    @IBOutlet weak var numberOfBeds: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell(_ ownerName: String,  _ numberOfBeds: String, _ numberOfBedrooms: String, _ numberOfPeaople: String){
        ownerLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        
        self.ownerLbl.text = ownerName
        self.numberOfBeds.text = numberOfBeds
        self.numberOfBedrooms.text = numberOfBedrooms
        self.numberOfPeaople.text = numberOfPeaople
    }
    
}
