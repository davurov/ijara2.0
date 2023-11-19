//
//  VerificationChildVC.swift
//  ijara
//
//  Created by Abduraxmon on 15/08/23.
//

import UIKit

protocol VerificationDelegate: AnyObject {
    func verified()
}

class VerificationChildVC: UIViewController {
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.addShadow()
            bottomView.layer.cornerRadius = 60
            bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    
    @IBOutlet weak var verifyBtn: UIButton!{
        didSet{
            verifyBtn.setTitle(SetLanguage.setLang(type: .verifyBtn), for: .normal)
        }
    }
    
    @IBOutlet weak var phoneVerLbl: UILabel!{
        didSet{
            phoneVerLbl.text = SetLanguage.setLang(type: .phoneVerLbl)
        }
    }
    
    @IBOutlet weak var otpView: OTPFieldView!
    weak var delegete: VerificationDelegate?
    var otpNumber = ""
    
    let partial = screenSize.height / 1.6

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOtpView()
    }
    
    func checkPassword(sms: String) {
        AuthManager.shared.verifyCode(smsCode: sms) { success in
            guard success else {
                Alert.showAlert(forState: .error, message: "Wrong Password")
                return
            }
            self.delegete?.verified()
        }
    }
    
    private func setupOtpView(){
            otpView.fieldsCount = 6
            otpView.fieldBorderWidth = 1
            otpView.cursorColor = UIColor.black
            otpView.displayType = .roundedCorner
            otpView.fieldSize = 40
            otpView.separatorSpace = 20
            otpView.shouldAllowIntermediateEditing = false
            otpView.delegate = self
            otpView.initializeUI()
        }
    
    
    @IBAction func verifyPressed(_ sender: Any) {
        checkPassword(sms: otpNumber)
    }
    
}

extension VerificationChildVC: OTPFieldViewDelegate{
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        true
    }
    func enteredOTP(otp: String) {
        otpNumber = otp
    }
    func hasEnteredAllOTP(hasEnteredAll: Bool) -> Bool {
        true
    }
}
