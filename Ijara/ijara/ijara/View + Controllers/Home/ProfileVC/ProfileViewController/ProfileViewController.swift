//
//  ProfileViewController.swift
//  ijara
//
//  Created by Sarvar Qosimov on 14/12/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SetLanguage.setLang(type: .profileTitle)
        navigationItem.backButtonTitle = SetLanguage.setLang(type: .profileForBackBtn)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
        navigationItem.backBarButtonItem?.tintColor = AppColors.mainColor
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : AppColors.customBlackText
        ]
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserProfileCell.nib(), forCellReuseIdentifier: UserProfileCell.identifier)
        tableView.register(SettingTVC.nib(), forCellReuseIdentifier: SettingTVC.identifier)
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let userProfileCell = tableView.dequeueReusableCell(withIdentifier: UserProfileCell.identifier, for: indexPath) as? UserProfileCell else { return UITableViewCell() }
            
            let userImage = UIImage().loadImage() ?? UIImage(systemName: "person.fill")
            let userName = UserDefaults.standard.string(forKey: Keys.userName) ?? SetLanguage.setLang(type: .user)
            
            userProfileCell.updateCell(userImage: userImage ?? UIImage(), userName: userName)
            
            return userProfileCell
        } else {
            guard let settingsCell = tableView.dequeueReusableCell(withIdentifier: SettingTVC.identifier, for: indexPath) as? SettingTVC else { return UITableViewCell() }
            
            switch indexPath.row {
            case 0:
                settingsCell.updateCell(
                    icon: UIImage(systemName: "questionmark.circle"),
                    settingName: SetLanguage.setLang(type: .about))
            case 1:
                settingsCell.updateCell(
                    icon: UIImage(systemName: "book"),
                    settingName: SetLanguage.setLang(type: .appLanguage))
            case 2:
                settingsCell.updateCell(
                    icon: UIImage(systemName: "lock"),
                    settingName: SetLanguage.setLang(type: .privcyPolicy))
            case 3:
                settingsCell.updateCell(
                    icon: UIImage(named: "companyLocation"),//translate
                    settingName: "Company location")
            default:
                settingsCell.updateCell(
                    icon: UIImage(systemName: "iphone.rear.camera"),
                    settingName: SetLanguage.setLang(type: .otherApps))
            }
            
            return settingsCell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let vc = EditProfileVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            switch indexPath.row {
            case 0:
                let vc = AboutAppVC()
                vc.infos = StaticDatas.aboutsUs
                vc.title = SetLanguage.setLang(type: .about)
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = ChooseLanguageVC()
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true)
            case 2:
                let vc = AboutAppVC()
                vc.infos = StaticDatas.privcyPolicy
                vc.title = SetLanguage.setLang(type: .privcyPolicy)
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            case 3:
                let vc = CompanyLocationDetailVC()
                vc.isWithYandexMap = true
                
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 24
                }
                
                present(vc, animated: true)
            default:
                let vc = OtherAppsVC()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return SetLanguage.setLang(type: .user)
        } else {
            return SetLanguage.setLang(type: .settings)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        33
    }
}
