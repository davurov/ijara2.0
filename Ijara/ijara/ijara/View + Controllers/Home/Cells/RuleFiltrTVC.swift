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
    
    static var btnPressed = Array(repeating: false, count: 4) //{
//        didSet {
//            RuleFiltrTVC.selectedParametrs = []
//            for role in btnPressed.enumerated() {
//                if role.element {
//                    switch role.offset {
//                    case 0: RuleFiltrTVC.selectedParametrs.append(1)
//                    case 1: RuleFiltrTVC.selectedParametrs.append(2)
//                    case 2: RuleFiltrTVC.selectedParametrs.append(3)
//                    default: RuleFiltrTVC.selectedParametrs.append(4)
//                    }
//                }
//            }
//        }
  //  }
    
//    static var selectedParametrs = [Int]()
        
    @IBOutlet var guestView: [UIView]!
    
    @IBOutlet weak var guestTypeLbl: UILabel! {
        didSet {
            guestTypeLbl.text = SetLanguage.setLang(type: .guestType)
            guestTypeLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        }
    }
    
    @IBOutlet weak var famelyLbl: UILabel!{
        didSet {
            famelyLbl.text = SetLanguage.setLang(type: .famely)
        }
    }
    
    @IBOutlet weak var femaleLbl: UILabel!{
        didSet {
            femaleLbl.text = SetLanguage.setLang(type: .female)
        }
    }
    
    @IBOutlet weak var maleLbl: UILabel!{
        didSet {
            maleLbl.text = SetLanguage.setLang(type: .male)
        }
    }
    
    @IBOutlet weak var mixLbl: UILabel!{
        didSet {
            mixLbl.text = SetLanguage.setLang(type: .mix)
        }
    }
    //MARK: Life cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setUpViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
        for i in 0..<guestView.count {
            guestView[i].addBorder(size: 0.5)
            guestView[i].layer.cornerRadius = 20
        }
    }
    
}
