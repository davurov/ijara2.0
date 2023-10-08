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
    @IBOutlet weak var nemberOfBedrooms: UILabel!
    @IBOutlet weak var nemberOfBeds: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
