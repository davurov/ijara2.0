//
//  AboutAppVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 24/11/23.
//

import UIKit

class AboutAppVC: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    @IBOutlet weak var contactUsBtn: UIButton!
    
    var infos: [(title: String, description: String)] = []
    let contactUsTitle = SetLanguage.setLang(type: .contactUs)
    let sendMessageTitle = SetLanguage.setLang(type: .sendMessage)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : AppColors.customBlackText
        ]
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func segmentSelected(_ sender: Any) {
        changeColor()
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        let vc = ContactVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func contactUsPressed(_ sender: Any) {
        let companyNumber = "+998901773363"
        companyNumber.callNumber()
    }
    
    private func changeColor(){
        if segment.selectedSegmentIndex == 0 {
            view.backgroundColor = .white
            navigationController?.navigationBar.tintColor = AppColors.mainColor
            navigationController?.navigationBar.backgroundColor = .clear
            contactUsBtn.backgroundColor = AppColors.mainColor
            
            sendMessageBtn.setTitleColor(AppColors.customBlackText, for: .normal)
            sendMessageBtn.layer.borderColor = AppColors.mainColor.cgColor
            contactUsBtn.setTitleColor(.white, for: .normal)
            sendMessageBtn.setTitle(" \(sendMessageTitle) ", for: .normal)
            contactUsBtn.setTitle(" \(contactUsTitle) ", for: .normal)
            
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : AppColors.customBlackText
            ]
        } else {
            view.backgroundColor = AppColors.customBlack
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.backgroundColor = .clear

            contactUsBtn.backgroundColor = .white
            
            sendMessageBtn.setTitleColor(.white, for: .normal)
            sendMessageBtn.layer.borderColor = UIColor.white.cgColor
            contactUsBtn.setTitleColor(AppColors.customBlackText, for: .normal)
            sendMessageBtn.setTitle(" \(sendMessageTitle) ", for: .normal)
            contactUsBtn.setTitle(" \(contactUsTitle) ", for: .normal)
            
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
        }
        tableView.reloadData()
    }
    private func setupViews(){
        navigationController?.navigationBar.tintColor = AppColors.mainColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AboutAppTVC", bundle: nil), forCellReuseIdentifier: "AboutAppTVC")
        tableView.backgroundColor = .clear
        
        segment.removeAllSegments()
        segment.backgroundColor = AppColors.selectedTabbarCollor
        segment.insertSegment(withTitle: "Light mode", at: 0, animated: true)
        segment.insertSegment(withTitle: "Dark mode", at: 1, animated: true)
        segment.setImage(UIImage(systemName: "sun.min"), forSegmentAt: 0)
        segment.setImage(UIImage(systemName: "moon.stars"), forSegmentAt: 1)
        segment.selectedSegmentIndex = 0
        
        sendMessageBtn.backgroundColor = .clear
        sendMessageBtn.layer.borderWidth = 2
        sendMessageBtn.layer.borderColor = AppColors.mainColor.cgColor
        sendMessageBtn.setTitleColor(AppColors.mainColor, for: .normal)
        sendMessageBtn.setTitle(" \(sendMessageTitle) ", for: .normal)
        sendMessageBtn.titleLabel?.numberOfLines = 0
        sendMessageBtn.layer.cornerRadius = 15
        sendMessageBtn.clipsToBounds = true
        
        contactUsBtn.backgroundColor = AppColors.mainColor
        contactUsBtn.setTitleColor(.white, for: .normal)
        contactUsBtn.setTitle(" \(contactUsTitle) ", for: .normal)
        contactUsBtn.titleLabel?.numberOfLines = 0
        contactUsBtn.layer.cornerRadius = 15
        contactUsBtn.clipsToBounds = true
    }
    
}

extension AboutAppVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AboutAppTVC", for: indexPath) as? AboutAppTVC else { return UITableViewCell() }
        
        let currentInfo = infos[indexPath.row]
        
        cell.updateCell(currentInfo.title, description: currentInfo.description)
        cell.backgroundColor = .clear
        
        if segment.selectedSegmentIndex == 0 {
            cell.titleLbl.textColor = .black
            cell.descriptionLbl.textColor = .black
        } else {
            cell.titleLbl.textColor = .white
            cell.descriptionLbl.textColor = .white
        }
        
        return cell
    }
}

extension AboutAppVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}
