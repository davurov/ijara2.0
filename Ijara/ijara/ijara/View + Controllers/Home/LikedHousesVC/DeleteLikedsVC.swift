//
//  DeleteLikedsVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 25/12/23.
//

import UIKit

protocol DeleteLikedsDelegate: AnyObject {
    func deleteAllProducts()
}

class DeleteLikedsVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var deleteDelegate: DeleteLikedsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
 
    @IBAction func yesBtnPressed(_ sender: Any) {
        deleteDelegate?.deleteAllProducts()
        dismiss(animated: false)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: false)
    }
    
    private func setupViews(){
        backView.layer.cornerRadius = 25
        backView.clipsToBounds = true
        
        yesButton.layer.cornerRadius = 15
        yesButton.clipsToBounds = true
        
        messageLbl.text = SetLanguage.setLang(type: .deleteLikedsMessage)
        yesButton.setTitle(SetLanguage.setLang(type: .yes), for: .normal)
        cancelButton.setTitle(SetLanguage.setLang(type: .cancel), for: .normal)
    }
    
}
