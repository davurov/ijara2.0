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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
