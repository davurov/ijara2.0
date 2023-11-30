//
//  EditProfileVC.swift
//  ijara
//
//  Created by Abduraxmon on 15/09/23.
//

import UIKit

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var profileIMG: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
    var imgUrl = ""
    let userInfos = UserDefaults.standard
    
    //MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getProfileData()
    }
    
    //MARK: @IBAction functions
    
    @IBAction func profilePictureBtnPressed(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func saveInformationBtnPressed(_ sender: Any) {
        updateProfile()
    }
    
    //MARK: functions
    
    func getProfileData(){
        profileIMG.image = UIImage().loadImage() ?? UIImage(systemName: "person.fill")
        nameTF.text = userInfos.string(forKey: Keys.userName)
        lastNameTF.text = userInfos.string(forKey: Keys.userLastName)
    }
    
    func setupViews(){
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        
        profileView.layer.borderColor = AppColors.customGray6.cgColor
        profileView.layer.borderWidth = 1
        
        nameTF.placeholder = SetLanguage.setLang(type: .firstNameTF)
        nameTF.layer.cornerRadius = 8
        nameTF.layer.borderColor = AppColors.customGray6.cgColor
        nameTF.layer.borderWidth = 1
        nameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 7))
        nameTF.leftViewMode = .always
        nameTF.contentVerticalAlignment = .center
        
        lastNameTF.placeholder = SetLanguage.setLang(type: .lastNameTF)
        lastNameTF.layer.cornerRadius = 8
        lastNameTF.layer.borderColor = AppColors.customGray6.cgColor
        lastNameTF.layer.borderWidth = 1
        lastNameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 7))
        lastNameTF.leftViewMode = .always
        lastNameTF.contentVerticalAlignment = .center
        
        saveBtn.setTitle(SetLanguage.setLang(type: .saveBtn), for: .normal)
        saveBtn.backgroundColor = AppColors.mainColor
    }
    
}

//MARK: Update Profile
extension EditProfileVC {

    func updateProfile(){
        if !(nameTF.text ?? "").isEmpty && !(lastNameTF.text ?? "").isEmpty {
            
            let newName = nameTF.text!
            let newLastName = lastNameTF.text!
            
            userInfos.set(newName, forKey: Keys.userName)
            userInfos.set(newLastName, forKey: Keys.userLastName)
            
            navigationController?.popViewController(animated: true)
        } else {
            Alert.showAlert(forState: .warning, message: SetLanguage.setLang(type: .emptyTfError))
        }
    }
    
}

//MARK: Get Image
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        profileIMG.image = editedImage
        editedImage.saveImage()
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
