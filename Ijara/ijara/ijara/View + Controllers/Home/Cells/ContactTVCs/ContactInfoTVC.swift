//
//  ContactInfoTVC.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 09/09/23.
//

import UIKit
import MapKit

class ContactInfoTVC: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    
    @IBOutlet weak var mainContact: UIButton!
    
    @IBOutlet weak var contactDescription: UILabel!
    
    //MARK: Elements
    
    static let identifire = String(describing: ContactInfoTVC.self)
    static func nib() -> UINib { UINib(nibName: identifire, bundle: nil) }
    
    var index = 0
    var openLocationMap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    @IBAction func openContactPressed(_ sender: Any) {
//        switch index {
//        case 0: openLocationMap?()
//        case 1: openPhoneCall("+998901773363")
//        case 2: openTelegramApp("bronlahelp")
//        default: break
//        }
//    }
    
    func updateCell(_ data: ContactInfoDM){
        contactImage.image = data.contactImage
        mainContact.setTitle(data.mainInfo, for: .normal)
        contactDescription.text = data.description
        
        contactImage.tintColor = AppColors.mainColor
    }
    
    private func openPhoneCall(_ phoneNumber: String){
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                print("Call is not installed, handle accordingly")
            }
        } else {
            print("Invalid URL, handle accordingly")
        }
    }
    
    private func openTelegramApp(_ userName: String){
        if let telegramURL = URL(string: "https://t.me/\(userName)") {
            if UIApplication.shared.canOpenURL(telegramURL) {
                UIApplication.shared.open(telegramURL, options: [:], completionHandler: nil)
            } else {
                print("Telegram app is not installed, handle accordingly")
            }
        } else {
            print("Invalid URL, handle accordingly")
        }
    }
    
}


