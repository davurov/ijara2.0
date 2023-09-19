//
//  ContactTVC.swift
//  ijara
//
//  Created by Abduraxmon on 19/09/23.
//

import UIKit

class ContactTVC: UITableViewCell {
    
    static let identifier: String = String(describing: ContactTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var firstNumberLbl: UILabel!
    @IBOutlet weak var secondNumber: UILabel!
    @IBOutlet weak var comingLbl: UILabel!
    @IBOutlet weak var leavingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
