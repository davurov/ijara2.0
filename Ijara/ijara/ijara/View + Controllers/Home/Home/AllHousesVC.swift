//
//  AllHousesVC.swift
//  ijara
//
//  Created by Sarvar Qosimov on 12/12/23.
//

import UIKit

class AllHousesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var houses: [CountryhouseData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = SetLanguage.setLang(type: .houses)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = false
        setupColView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setValues(_ houses: [CountryhouseData]) {
        self.houses = houses
    }
    
    private func setupColView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AllHousesCVC.nib(), forCellWithReuseIdentifier: AllHousesCVC.identifier)
    }
    
}

extension AllHousesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        houses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllHousesCVC.identifier, for: indexPath) as? AllHousesCVC else { return UICollectionViewCell() }
        
        cell.updateCell(houses[indexPath.item])
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
}

extension AllHousesVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        if houses[indexPath.item].name.count > 13 {
            return CGSize(width: screenSize.width * 0.441, height: 275)
        } else {
            return CGSize(width: screenSize.width * 0.441, height: 255)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = HomeDetailVC()
        vc.getData(id: houses[indexPath.row].id)
        vc.price.weekday = houses[indexPath.item].priceForWeekends
        vc.price.wrking = houses[indexPath.item].priceForWorkingDays
        vc.hidesBottomBarWhenPushed = true
        vc.navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(vc, animated: true)
    }
}
