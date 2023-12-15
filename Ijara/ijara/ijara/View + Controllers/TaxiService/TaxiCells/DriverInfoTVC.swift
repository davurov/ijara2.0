//
//  DriverInfoTVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 04/12/23.
//

import UIKit

class DriverInfoTVC: UITableViewCell {
    
    @IBOutlet weak var driverNameLbl: UILabel!
    
    @IBOutlet weak var driverNameTitle: UILabel!
    
    @IBOutlet weak var commentLbl: UILabel!
    
    @IBOutlet weak var numbersToContactLbl: UILabel!
    
    @IBOutlet weak var phone1Lbl: UILabel!
    
    @IBOutlet weak var phone2Lbl: UILabel!
    
    @IBOutlet weak var phoneNumber1Lbl: UILabel!
    
    @IBOutlet weak var phoneNumber2Lbl: UILabel!

    static let identifier: String = String(describing: DriverInfoTVC.self)
    static func nib() -> UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .white
        }
    }
    
    func setValues(taxi: TaxiDM) {
        driverNameLbl.text = taxi.driverName
        commentLbl.text = taxi.coments
        phoneNumber1Lbl.text = taxi.telNumber1
        phoneNumber2Lbl.text = taxi.telNumber2
    }
    
    private func setupViews(){
        driverNameTitle.text = SetLanguage.setLang(type: .hostedByLbl)
        numbersToContactLbl.text = SetLanguage.setLang(type: .contactInfo)
        phone1Lbl.text = "\(SetLanguage.setLang(type: .phoneLbl)) 1: "
        phone2Lbl.text = "\(SetLanguage.setLang(type: .phoneLbl)) 2: "
        commentLbl.addShadowCustom(offset: CGSize(width: 3, height: 3), color: AppColors.mainColor.cgColor, radius: 3, opacity: 0.25)
        commentLbl.layer.cornerRadius = 15
        commentLbl.clipsToBounds = true
    }
    
}
