//
//  CommentTVC.swift
//  ijara
//
//  Created by Abduraxmon on 19/09/23.
//

enum CommentState {
    case more
    case less
    case noBtn
}
protocol CommentDelegate:AnyObject {
    func readMorePressed(size: CGFloat)
}

import UIKit

class CommentTVC: UITableViewCell {
    
    static let identifier: String = String(describing: CommentTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var ownerNameLbl: UILabel! {
        didSet {
            ownerNameLbl.text = SetLanguage.setLang(type: .commentByOwner)
            ownerNameLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        }
    }
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var readBtn: UIButton! {
        didSet {
            readBtn.setTitle(SetLanguage.setLang(type: .readMoreBtn), for: .normal)
        }
    }
    @IBOutlet weak var borderConst: NSLayoutConstraint!
    
    var commentState: CommentState = .less
    weak var delegate: CommentDelegate?
    var comment = "" {
        didSet {
            resizeComment()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    //MARK: functions
    
    func updateCell(_ comment: String){
        commentLbl.text = comment
        commentLbl.setNeedsLayout()
        commentLbl.layoutIfNeeded()
        resizeComment()
    }
    
    func setUpViews() {
        
        borderView.addBorder(size: 0.5)
        readBtn.addBorder(size: 1)
    }
    
    func resizeComment() {
        if commentLbl.frame.height < 190 {
            readBtn.isHidden = true
            let height = commentLbl.frame.height
            borderConst.constant = height + 20
            delegate?.readMorePressed(size: height + 110)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func readPressed(_ sender: Any) {
        
        if commentState == .less {
            let height = commentLbl.frame.height + 10
            borderConst.constant = height
            readBtn.setTitle(SetLanguage.setLang(type: .readLess), for: .normal)
            commentState = .more
            delegate?.readMorePressed(size: height + 120)
        } else {
            delegate?.readMorePressed(size: 280)
            borderConst.constant = 160
            readBtn.setTitle(SetLanguage.setLang(type: .readMoreBtn), for: .normal)
            commentState = .less
        }
    }
    
}
