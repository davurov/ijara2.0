//
//  RuleFiltrTVC.swift
//  ijara
//
//  Created by Abduraxmon on 25/09/23.
//

import UIKit

class RuleFiltrTVC: UITableViewCell {
    
    static let identifier: String = String(describing: RuleFiltrTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    static var btnPressed = Array(repeating: false, count: 4)
    
    @IBOutlet var guestView: [UIView]!
    
    @IBOutlet weak var guestTypeLbl: UILabel!
    
    @IBOutlet weak var famelyLbl: UILabel!
    
    @IBOutlet weak var femaleLbl: UILabel!
    
    @IBOutlet weak var maleLbl: UILabel!
    
    @IBOutlet weak var mixLbl: UILabel!
    
    //MARK: Life cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setUpViews()
    }
    
    //MARK: @IBAction functions
    @IBAction func ruleBtnPressed(_ sender: UIButton) {
        if !RuleFiltrTVC.btnPressed[sender.tag] {
            guestView[sender.tag].backgroundColor = AppColors.customClear
            RuleFiltrTVC.btnPressed[sender.tag] = !RuleFiltrTVC.btnPressed[sender.tag]
            UIView.animate(withDuration: 0.5) {
                self.guestView[sender.tag].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        } else {
            guestView[sender.tag].backgroundColor = .clear
            RuleFiltrTVC.btnPressed[sender.tag] = !RuleFiltrTVC.btnPressed[sender.tag]
            UIView.animate(withDuration: 0.5) {
                self.guestView[sender.tag].transform = .identity
            }
        }
    }
    
    //MARK: functions
    
    func clearChanges(){
        for each in 0...3 {
            RuleFiltrTVC.btnPressed[each] = false
            guestView[each].backgroundColor = .clear
            UIView.animate(withDuration: 0.5) {
                self.guestView[each].transform = .identity
            }
        }
    }
    
    func setUpViews() {
        guestTypeLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        guestTypeLbl.text = SetLanguage.setLang(type: .guestType)
        famelyLbl.text    = SetLanguage.setLang(type: .famely)
        femaleLbl.text    = SetLanguage.setLang(type: .female)
        mixLbl.text       = SetLanguage.setLang(type: .mix)
        maleLbl.text      = SetLanguage.setLang(type: .male)
        
        for i in 0..<guestView.count {
            guestView[i].addBorder(size: 1)
            guestView[i].layer.cornerRadius = 20
        }
    }
    
}
