//
//  UserProfileCell.swift
//  ijara
//
//  Created by Sarvar Qosimov on 14/12/23.
//

import UIKit

class UserProfileCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var showProfileLbl: UILabel!
    
    
    static let identifier = String(describing: UserProfileCell.self)
    static func nib() -> UINib { UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showProfileLbl.text = SetLanguage.setLang(type: .showProfile)
    }
    
    func updateCell(userImage: UIImage, userName: String){
        self.userImage.image = userImage
        self.userNameLbl.text = userName
    }
    
}
