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
    
    var btnPressed = Array(repeating: false, count: 4)
    @IBOutlet var guestView: [UIView]!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       setUpViews()
    }
    
    func setUpViews() {
        for i in 0..<guestView.count {
            guestView[i].addBorder(size: 0.5)
            guestView[i].layer.cornerRadius = 20
        }
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func ruleBtnPressed(_ sender: UIButton) {
        if !btnPressed[sender.tag] {
            guestView[sender.tag].backgroundColor = AppColors.customClear
            btnPressed[sender.tag] = !btnPressed[sender.tag]
            UIView.animate(withDuration: 0.5) {
                self.guestView[sender.tag].transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        } else {
            guestView[sender.tag].backgroundColor = .clear
            btnPressed[sender.tag] = !btnPressed[sender.tag]
            UIView.animate(withDuration: 0.5) {
                self.guestView[sender.tag].transform = .identity
            }
        }
    }
    
}
