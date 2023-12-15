//
//  SendMessageTVC.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 09/09/23.
//

import UIKit

class SendMessageTVC: UITableViewCell {
    
    @IBOutlet weak var sendMessageTF: UITextField!
    
    static let identifire = String(describing: SendMessageTVC.self)
    static func nib() -> UINib { UINib(nibName: identifire, bundle: nil) }
    
    var cellIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: SetLanguage.setLang(type: .doneToolButton), style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]
        
        sendMessageTF.inputAccessoryView = toolbar
        sendMessageTF.delegate = self
        sendMessageTF.addBorder(size: 1)
    }
    
    @objc func doneButtonTapped() {
        sendMessageTF.resignFirstResponder()
    }
    
    func updateCell(_ messagePlaceholder: String){
        sendMessageTF.placeholder = messagePlaceholder
        
        if messagePlaceholder == SetLanguage.setLang(type: .enterNameTF) {
            sendMessageTF.text = UserDefaults.standard.string(forKey: Keys.userName)
        }
    }
    
}

extension SendMessageTVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        ContactVC.messages[cellIndex] = textField.text ?? ""
    }
}
