//
//  NewsVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 25/11/23.
//

import UIKit

class NewsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SetLanguage.setLang(type: .news)
        navigationController?.navigationBar.prefersLargeTitles = false
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.register(NewsImagesTVC.nib(), forCellReuseIdentifier: NewsImagesTVC.identifire)
        tableView.register(AboutAppTVC.nib(), forCellReuseIdentifier: AboutAppTVC.identifire)
        
        closeBtn.setTitle(SetLanguage.setLang(type: .close), for: .normal)
        closeBtn.layer.cornerRadius = 10
        closeBtn.clipsToBounds = true
    }
    
}

extension NewsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: NewsImagesTVC.identifire, for: indexPath) as? NewsImagesTVC else { return UITableViewCell() }
            
            return photoCell
        } else {
            guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: AboutAppTVC.identifire, for: indexPath) as? AboutAppTVC else { return UITableViewCell() }
            descriptionCell.updateCell(
                "",
                description: """
Chorvoq – bu yerda to‘liq dam olish, tabiat qo‘ynidan bahramand bo‘lish va bir yillik quvvatingizni to‘ldirishingiz mumkin. Siz qulay va faol dam olish uchun kerak bo'lgan hamma narsani topasiz: go'zal landshaftlardan tortib turli xil dam olish turlarigacha. Qisqa yoki uzaytirilgan dam olish uchun Chorvoq eng yaxshi tanlovdir.

Chorvoq faol dam olish uchun turli imkoniyatlarni taqdim etadi. Bu yerda ko‘plab baliq turlari yashaydi. Bu suvda sport va dam olishni yaxshi ko'radiganlar uchun ajoyib joy. Siz tezyurar qayiqni ijaraga olishingiz, ko'lni o'rganishingiz va salqin suvda sayr qilishingiz mumkin. Chorvoqda tog‘larda piyoda sayr qilish, velosport va har qanday darajadagi mashg‘ulotlar uchun ko‘plab yo‘llar va marshrutlar mavjud.
"""
            )
            return descriptionCell
        }
    }
}
