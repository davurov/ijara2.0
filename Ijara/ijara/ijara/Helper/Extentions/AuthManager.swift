//
//  AuthManager.swift
//  ijara
//
//  Created by Abduraxmon on 17/08/23.
//
import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    private let auth = Auth.auth()
    private  var verificationId: String?
    
    public func startAuth(phoneNumber: String, complition: @escaping (Bool) -> Void ) {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                Alert.showAlert(forState: .error, message: error?.localizedDescription ?? "")
                if let maybeError = error { //if there was an error, handle it
                    let err = maybeError as NSError
                        switch err.code {
                        case AuthErrorCode.invalidPhoneNumber.rawValue:
                            Alert.showAlert(forState: .error, message: "")
                        case AuthErrorCode.missingPhoneNumber.rawValue:
                            Alert.showAlert(forState: .error, message: "")
                        default:
                            Alert.showAlert(forState: .error, message: "")
                        }
                    }
                complition(false)
                return
            }
            self?.verificationId = verificationId
            complition(true)
        }
    }
    
    
    public func verifyCode(smsCode: String, complition: @escaping (Bool) -> Void) {
        
        guard let verificationId = verificationId else {
            complition(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                if let maybeError = error { //if there was an error, handle it
                    let err = maybeError as NSError
                        switch err.code {
                        case AuthErrorCode.wrongPassword.rawValue:
                            Alert.showAlert(forState: .error, message: "")
                        case AuthErrorCode.tooManyRequests.rawValue:
                            Alert.showAlert(forState: .error, message: "")
                        default:
                            Alert.showAlert(forState: .error, message: "")
                        }
                    }
                complition(false)
                return
            }
            UserDefaults.standard.set(self.auth.currentUser?.uid ?? "tok", forKey: Keys.token)
            complition(true)
        }
        
    }
}
