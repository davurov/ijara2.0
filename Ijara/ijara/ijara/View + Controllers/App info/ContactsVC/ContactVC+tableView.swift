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

        tableView.register(
            UINib(nibName: "HeaderOfContactTVC", bundle: nil),
            forCellReuseIdentifier: "HeaderOfContactTVC"
        )
        tableView.register(
            UINib(nibName: "ContactInfoTVC", bundle: nil),
            forCellReuseIdentifier: "ContactInfoTVC"
        )
        tableView.register(
            UINib(nibName: "SendMessageTVC", bundle: nil),
            forCellReuseIdentifier: "SendMessageTVC"
        )
        tableView.register(
            UINib(nibName: "OurLocationTVC", bundle: nil),
            forCellReuseIdentifier: "OurLocationTVC"
        )
    }
}

//MARK: UITableViewDataSource
extension ContactVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            ///` cell for "Back to home"
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderOfContactTVC", for: indexPath) as? HeaderOfContactTVC else { return UITableViewCell() }
            
            headerCell.backDelegate = self
            headerCell.selectionStyle = .none
            
            return headerCell
        } else if indexPath.section == 1 {
            ///` cell for contacts
            guard let infoCell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoTVC", for: indexPath) as? ContactInfoTVC else { return UITableViewCell() }
            
            infoCell.updateCell(contacts[indexPath.row])
            infoCell.index = indexPath.row
            infoCell.selectionStyle = .none
            
            infoCell.openLocationMap = { [weak self] in
                guard let strongSelf = self else { return }
                
                let vc = CompanyLocationDetailVC()
                strongSelf.present(vc, animated: true)
            }
            
            return infoCell
        } else {
            ///` cell to send message
            guard let sendMessageCell = tableView.dequeueReusableCell(withIdentifier: "SendMessageTVC", for: indexPath) as? SendMessageTVC else { return UITableViewCell() }
            
            sendMessageCell.updateCell(sendMessageRequirements[indexPath.row])
            sendMessageCell.selectionStyle = .none
            sendMessageCell.sendMessageTF.tag = indexPath.row
            sendMessageCell.cellIndex = indexPath.row
            
            return sendMessageCell
            
        }
    }
    
}

extension ContactVC: BackToMainPageDelegate {
    func backPressed() {
        navigationController?.popViewController(animated: true)
    }
}
