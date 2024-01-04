//
//  ContactVC+tableView.swift
//  IjaraSarvar
//
//  Created by Sarvar Qosimov on 09/09/23.
//

import Foundation
import UIKit

//MARK: setupTableView
extension ContactVC {
    func setupTableView(){
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ContactInfoTVC.nib(), forCellReuseIdentifier: ContactInfoTVC.identifire)
        tableView.register(SendMessageTVC.nib(), forCellReuseIdentifier: SendMessageTVC.identifire)
    }
}

//MARK: UITableViewDataSource
extension ContactVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            ///` cell for contacts
            guard let infoCell = tableView.dequeueReusableCell(withIdentifier: ContactInfoTVC.identifire, for: indexPath) as? ContactInfoTVC else { return UITableViewCell() }
            
            infoCell.updateCell(contacts[indexPath.row])
            infoCell.index = indexPath.row
            infoCell.selectionStyle = .none
            
            infoCell.openLocationMap = { [weak self] in
                guard let strongSelf = self else { return }
                
                let vc = CompanyLocationDetailVC()
                vc.isWithYandexMap = false
                strongSelf.present(vc, animated: true)
            }
            
            return infoCell
        } else {
            ///` cell to send message
            guard let sendMessageCell = tableView.dequeueReusableCell(withIdentifier: SendMessageTVC.identifire, for: indexPath) as? SendMessageTVC else { return UITableViewCell() }
            
            sendMessageCell.updateCell(sendMessageRequirements[indexPath.row])
            sendMessageCell.selectionStyle = .none
            sendMessageCell.sendMessageTF.tag = indexPath.row
            sendMessageCell.cellIndex = indexPath.row
            
            return sendMessageCell
            
        }
    }
    
}

extension ContactVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: openCompanyLocation()
            case 1: openPhoneCall("+998901773363")
            case 2: openTelegramApp("bronlahelp")
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return SetLanguage.setLang(type: .contactUs)
        } else {
            return SetLanguage.setLang(type: .sendMessage)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        33
    }
}
