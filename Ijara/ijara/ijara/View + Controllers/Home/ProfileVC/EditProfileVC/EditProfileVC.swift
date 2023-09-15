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
    
    @IBOutlet weak var saveBtn: UIButton!{
        didSet{
            saveBtn.setTitle("Save", for: .normal)
            saveBtn.backgroundColor = AppColors.mainColor
        }
    }
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    @IBOutlet weak var profileView: UIView!{
        didSet{
            profileView.layer.borderColor = AppColors.customGray6.cgColor
            profileView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var nameTF: UITextField!{
        didSet{
            nameTF.layer.cornerRadius = 8
            nameTF.layer.borderColor = AppColors.customGray6.cgColor
            nameTF.layer.borderWidth = 1
            nameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 7))
            nameTF.leftViewMode = .always
            nameTF.contentVerticalAlignment = .center
            
        }
    }
    @IBOutlet weak var lastNameTF: UITextField!{
        didSet{
            lastNameTF.layer.cornerRadius = 8
            lastNameTF.layer.borderColor = AppColors.customGray6.cgColor
            lastNameTF.layer.borderWidth = 1
            lastNameTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 7))
            lastNameTF.leftViewMode = .always
            lastNameTF.contentVerticalAlignment = .center
        }
    }
    var imgUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileData()
        profileIMG.image = UIImage().loadImage() ?? UIImage(systemName: "person.fill")
    }
    
    func getProfileData(){
        let info = UserDefaults.standard.array(forKey: Keys.userInfo) as? [String]
        phoneNumberLbl.text = info?.first ?? ""
        nameTF.text = info?.last ?? "User"
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
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
    
}

//MARK: Update Profile
extension EditProfileVC {
    
    func updateProfile(){
        if !nameTF.text!.isEmpty && !lastNameTF.text!.isEmpty{
            var info = UserDefaults.standard.array(forKey: Keys.userInfo) as? [String]
            info![1] = nameTF.text!
            UserDefaults.standard.set(info, forKey: Keys.userInfo)
        }else{
            Alert.showAlert(forState: .warning, message: "Please complete name field")
        }
    }
    
}

//MARK: Get Image
extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        profileIMG.image = editedImage
        editedImage.saveImage()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
