//
//  OwnerInfoVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 10/12/23.
//

import UIKit

class OwnerInfoVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var countryHouseDM: CountryhouseData!
    var commentCellSize: CGFloat = 280
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setValues(house: CountryhouseData) {
        self.countryHouseDM = house
    }

    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentTVC.nib(), forCellReuseIdentifier: CommentTVC.identifier)
        tableView.register(ContactTVC.nib(), forCellReuseIdentifier: ContactTVC.identifier)
    }
    
}

extension OwnerInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let contactCell = tableView.dequeueReusableCell(withIdentifier: ContactTVC.identifier, for: indexPath) as! ContactTVC
            
            guard let countryHouseDM = countryHouseDM else { return contactCell }
            
            contactCell.updateCell(
                countryHouseDM.firstphone,
                countryHouseDM.secondphone,
                countryHouseDM.startTime,
                countryHouseDM.finishTime
            )
            
            return contactCell
        } else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: CommentTVC.identifier, for: indexPath) as! CommentTVC
            
            guard let countryHouseDM = countryHouseDM else { return commentCell }
            
            commentCell.delegate = self
            commentCell.updateCell(countryHouseDM.comment)
            
            return commentCell
            
        }

    }
}

extension OwnerInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 230
        } else {
            return commentCellSize
        }
    }
}

extension OwnerInfoVC: CommentDelegate {
    func readMorePressed(size: CGFloat) {
        func readMorePressed(size: CGFloat) {
            commentCellSize = size
            tableView.reloadData()
        }
    }
}
