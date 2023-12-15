//
//  ContactVC.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 09/09/23.
//

import UIKit
import MessageUI

class ContactVC: UIViewController {
    
    //MARK: Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    //MARK: Variables
    var contacts = [
    ContactInfoDM(
        contactImage: UIImage(systemName: "house")!,
        mainInfo: SetLanguage.setLang(type: .companyAdress),
        description: SetLanguage.setLang(type: .companyAdressDetail)
    ),
    ContactInfoDM(
        contactImage: UIImage(systemName: "phone")!,
        mainInfo: "+998901773363",
        description: SetLanguage.setLang(type: .workingTimeForCall)
    ),
    ContactInfoDM(
        contactImage: UIImage(systemName: "location.circle.fill")!,
        mainInfo: "+998901773364",
        description: SetLanguage.setLang(type: .sendAnyTime)
    ),
    ContactInfoDM(
        contactImage: UIImage(systemName: "envelope")!,
        mainInfo: "bronlauz@gmail.com",
        description: SetLanguage.setLang(type: .sendAnyTime)
    )
    ]
    
    var sendMessageRequirements = [
        SetLanguage.setLang(type: .enterNameTF),
        SetLanguage.setLang(type: .enterEmailTF),
        SetLanguage.setLang(type: .enterThemTF),
        SetLanguage.setLang(type: .enterMessageTF)
    ]
    
    static var messages: [String] = []
    
    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SetLanguage.setLang(type: .contacts)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .systemGray6
        sendMessageBtn.setTitle(SetLanguage.setLang(type: .sendMessage), for: .normal)
        setupTableView()
        
        ContactVC.messages = Array(repeating: "", count: 4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.backgroundColor = .white
//    }
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? SendMessageTVC {
                    cell.sendMessageTF.layer.borderColor = UIColor.clear.cgColor
                    let text = cell.sendMessageTF.text ?? ""
                    if text.isEmpty {
                        Alert.showAlert(forState: .warning, message: SetLanguage.setLang(type: .emptyField))
                        cell.sendMessageTF.layer.borderColor = UIColor.red.cgColor
                        cell.sendMessageTF.layer.borderWidth = 2
                    } else {
                        sendMessage()
                    }
                }
            }
        }
    }
    
    func sendMessage(){
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["bronlauz@gmail.com"])
            mailComposeViewController.setToRecipients([ContactVC.messages[0]])

            mailComposeViewController.setSubject(ContactVC.messages[2])
            mailComposeViewController.setMessageBody(ContactVC.messages[3], isHTML: false)
            
            Alert.showAlertWithBool(forState: .success, message: SetLanguage.setLang(type: .successfullySend), isShow: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.dismiss(animated: true)
            }
        } else {
            print("Device not configured to send mail.")
        }
    }
    
    func openPhoneCall(_ phoneNumber: String){
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                print("Call is not installed, handle accordingly")
            }
        } else {
            print("Invalid URL, handle accordingly")
        }
    }
    
    func openTelegramApp(_ userName: String){
        if let telegramURL = URL(string: "https://t.me/\(userName)") {
            if UIApplication.shared.canOpenURL(telegramURL) {
                UIApplication.shared.open(telegramURL, options: [:], completionHandler: nil)
            } else {
                print("Telegram app is not installed, handle accordingly")
            }
        } else {
            print("Invalid URL, handle accordingly")
        }
    }
    
    func openCompanyLocation(){
        let vc = CompanyLocationDetailVC()
        vc.isWithYandexMap = false
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        
        present(vc, animated: true)
    }
    
}

extension ContactVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        navigationController?.popViewController(animated: true)
    }
}
