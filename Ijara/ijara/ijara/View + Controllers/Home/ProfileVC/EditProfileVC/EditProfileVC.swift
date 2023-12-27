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
    @IBOutlet weak var emailTF: UITextField!
    
    var imgUrl = ""
    let userInfos = UserDefaults.standard
    
    //MARK: Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SetLanguage.setLang(type: .editProfile)
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
        emailTF.text = userInfos.string(forKey: Keys.userEmail)
    }
    
    func setupViews(){
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        
        profileView.layer.borderColor = AppColors.customGray6.cgColor
        profileView.layer.borderWidth = 1
        
        nameTF.placeholder = SetLanguage.setLang(type: .firstNameTF)
        changeTfAppearance(tf: &nameTF)
        
        lastNameTF.placeholder = SetLanguage.setLang(type: .lastNameTF)
        changeTfAppearance(tf: &lastNameTF)
        
        emailTF.placeholder = "Email (\(SetLanguage.setLang(type: .optionalTF)))"
        changeTfAppearance(tf: &emailTF)
        
        saveBtn.setTitle(SetLanguage.setLang(type: .saveBtn), for: .normal)
        saveBtn.backgroundColor = AppColors.mainColor
    }
    
    func changeTfAppearance(tf: inout UITextField){
        tf.layer.cornerRadius = 8
        tf.layer.borderColor = AppColors.customGray6.cgColor
        tf.layer.borderWidth = 1
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 7))
        tf.leftViewMode = .always
        tf.contentVerticalAlignment = .center
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
            userInfos.set(
                emailTF.text ?? "",
                forKey: Keys.userEmail
            )
            
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
