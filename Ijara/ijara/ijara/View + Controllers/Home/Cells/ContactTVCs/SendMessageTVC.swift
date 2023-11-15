//
//  SendMessageTVC.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 09/09/23.
//

import UIKit

class SendMessageTVC: UITableViewCell {
    
    @IBOutlet weak var sendMessageTF: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let toolbar = UIToolbar()
        toolbar.sizeToFit() 
        let doneButton = UIBarButtonItem(title: SetLanguage.setLang(type: .doneToolButton), style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        sendMessageTF.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        sendMessageTF.resignFirstResponder()
    }

    func updateCell(_ messagePlaceholder: String){
        sendMessageTF.placeholder = messagePlaceholder
    }
    
}
