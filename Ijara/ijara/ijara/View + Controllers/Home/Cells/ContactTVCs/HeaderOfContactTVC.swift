//
//  HeaderOfContactTVC.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 09/09/23.
//

import UIKit

protocol BackToMainPageDelegate: AnyObject {
    func backPressed()
}

class HeaderOfContactTVC: UITableViewCell {
    
    @IBOutlet weak var contactUsLbl: UILabel!
    
    @IBOutlet weak var mainPageLbl: UIButton!
    
    @IBOutlet weak var contactUsBackLbl: UILabel!
    
    weak var backDelegate: BackToMainPageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    
    @IBAction func mainPageBtnPressed(_ sender: Any) {
        guard let backDelegate = backDelegate else { return }
        backDelegate.backPressed()
    }
    
    func setupViews(){
        contactUsLbl.text = SetLanguage.setLang(type: .contactUs)
        mainPageLbl.setTitle(SetLanguage.setLang(type: .mainPage), for: .normal)
        contactUsBackLbl.text = SetLanguage.setLang(type: .contactUs)
    }
    
}
