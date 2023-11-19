//
//  RegisterChildVC.swift
//  ijara
//
//  Created by Abduraxmon on 14/08/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

protocol RegisterDelegete {
    func startPressed()
    func nextPressed()
}

class RegisterChildVC: UIViewController {

    
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet var contViews: [UIView]!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var scrollArea: UIView!{
        didSet{
            scrollArea.addShadowByHand(offset: CGSize(width: 0, height: 0), color: AppColors.customBlack.cgColor, radius: 5, opacity: 0.2)
            scrollArea.layer.cornerRadius = 50
            scrollArea.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet weak var startBtn: UIButton! {
        didSet {
            startBtn.setTitle(SetLanguage.setLang(type: .getStartBtn), for: .normal)
        }
    }
    
    
    let partial = screenSize.height / 1.6
    var phoneNumber = ""
    var btnPressed = 0
    var formatedNumber = "XX XXX XX XX"
    var delegete: RegisterDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    /// Registers number to firebase
    /// - Parameter number: string from number textfield
    func register(number: String) {
        var isValid = false
        guard phoneTF.text != "" else {
            Alert.showAlert(forState: .error, message: "Enter number")
            return
        }
        guard nameTF.text != "" else {
            Alert.showAlert(forState: .error, message: "Enter number")
            return
        }
        UserDefaults.standard.set([phoneTF.text, nameTF.text], forKey: Keys.userInfo)
        let numberWithCode = "+998" + number.replacingOccurrences(of: " ", with: "")
        AuthManager.shared.startAuth(phoneNumber: numberWithCode) { success in
            
            guard success else {
                Alert.showAlert(forState: .error, message: "Enter valid phone number")
                print("AuthManager, error")
                return
            }
            
            if self.btnPressed == 1 {
                self.delegete?.nextPressed()
            }
        }
    }
    
    @IBAction func startPressed(_ sender: Any) {
        if btnPressed == 1 {
            print("phoneTF.text:", phoneTF.text ?? "")
            register(number: phoneTF.text ?? "")
        } else {
            delegete?.startPressed()
            UIView.animate(withDuration: 0.5) { [self] in
                startBtn.transform = CGAffineTransform(translationX: 0, y: partial)
            }
            startBtn.setTitle("Next", for: .normal)
            infoStack.isHidden = false
            btnPressed += 1
        }
    }
    
    func setupViews() {
        for (i, _) in contViews.enumerated() {
            contViews[i].addBorder(size: 2)
            contViews[i].layer.cornerRadius = 20
        }
        phoneTF.delegate = self
    }
    
    func formatPhoneNumber(exNumber: String) {
        formatedNumber = ""
        phoneTF.placeholder = ""
        
        for number in exNumber {
            if number != " " {
                formatedNumber.append("X")
                phoneTF.placeholder?.append("-")
            } else {
                formatedNumber.append(" ")
                phoneTF.placeholder?.append(" ")
            }
        }
    }
    
}

extension RegisterChildVC: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
      
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneTF.text = phoneNumber


    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        phoneNumber = phoneTF.text!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text?.formatPhoneNumber(with: formatedNumber, phone: newString)
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneTF.resignFirstResponder()
        return true
    
    }
}
