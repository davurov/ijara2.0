//
//  ContactVC.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 09/09/23.
//

import UIKit

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

    //MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SetLanguage.setLang(type: .contacts)
        navigationItem.backButtonTitle = SetLanguage.setLang(type: .contacts)
        sendMessageBtn.setTitle(SetLanguage.setLang(type: .sendMessage), for: .normal)
        setupTableView()
    }
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths {
                if let cell = tableView.cellForRow(at: indexPath) as? SendMessageTVC {
                    cell.sendMessageTF.layer.borderColor = UIColor.clear.cgColor
                    let text = cell.sendMessageTF.text ?? ""
                    if text.isEmpty {
                        Alert.showAlert(forState: .warning, message: "Empty field")
                        cell.sendMessageTF.layer.borderColor = UIColor.red.cgColor
                        cell.sendMessageTF.layer.borderWidth = 2
                    }
                }
            }
        }
        
    }
    
}
