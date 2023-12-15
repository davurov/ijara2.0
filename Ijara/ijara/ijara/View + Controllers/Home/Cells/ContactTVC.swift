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
    
    @IBOutlet weak var contactInfoLbl: UILabel! {
        didSet {
            contactInfoLbl.text = SetLanguage.setLang(type: .contactInfo)
//            contactInfoLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        }
    }
    @IBOutlet weak var firstNumberLbl: UILabel!
    @IBOutlet weak var phone1Lbl: UILabel!
    @IBOutlet weak var secondNumber: UILabel!
    @IBOutlet weak var phone2Lbl: UILabel!
    @IBOutlet weak var comingLbl: UILabel!
    @IBOutlet weak var comingTimeLbl: UILabel!
    @IBOutlet weak var leavingLbl: UILabel!
    @IBOutlet weak var leavingTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.backgroundColor = .white
        }
    }
    
    func updateCell(_ phone1: String, _ phone2:  String, _ comingTime: String, _ leavingTime: String){
        firstNumberLbl.text = "\(SetLanguage.setLang(type: .phoneLbl)) 1 : "
        phone1Lbl.text = phone1
        secondNumber.text = "\(SetLanguage.setLang(type: .phoneLbl)) 2 : "
        phone2Lbl.text = phone2
        comingLbl.text = "\(SetLanguage.setLang(type: .comingTime)): "
        comingTimeLbl.text = comingTime
        leavingLbl.text = "\(SetLanguage.setLang(type: .leavingTime)): "
        leavingTimeLbl.text = leavingTime
    }
    
}
