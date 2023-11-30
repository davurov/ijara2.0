//
//  BedsTVC.swift
//  ijara
//
//  Created by Abduraxmon on 26/09/23.
//

import UIKit

class BedsTVC: UITableViewCell {
    
    static let identifier: String = String(describing: BedsTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    static var numberOfPeople: Int?
    
    @IBOutlet weak var numberOfPeopleLbl: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nums = ["1","2","3","4","5","6","7","8","9+"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    //MARK: functions
    
    func setupViews() {
        numberOfPeopleLbl.text = SetLanguage.setLang(type: .numberOfPeople)
        numberOfPeopleLbl.font = UIFont(name: "American Typewriter Condensed Bold", size: 25)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCVC.nib(), forCellWithReuseIdentifier: CategoryCVC.identifier)
    }
    
    func clearChanges(){
        if let numberOfPeople = BedsTVC.numberOfPeople {
            
            BedsTVC.numberOfPeople = nil
            
            let selectedCell = collectionView.cellForItem(at: IndexPath(item: numberOfPeople-1, section: 0)) as? CategoryCVC
            selectedCell?.containerView.backgroundColor = .clear
            selectedCell?.categoryNameLbl.textColor = .black
        }
    }
    
}

//MARK: UICollectionViewDataSource
extension BedsTVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCVC.identifier, for: indexPath) as! CategoryCVC
        
        cell.categoryNameLbl.text = nums[indexPath.row]
        
        return cell
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension BedsTVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        BedsTVC.numberOfPeople = indexPath.item + 1
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCVC
        selectedCell?.containerView.backgroundColor = AppColors.mainColor
        selectedCell?.categoryNameLbl.textColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            let selectedCell = collectionView.cellForItem(at: indexPath) as? CategoryCVC
            selectedCell?.containerView.backgroundColor = .clear
            selectedCell?.categoryNameLbl.textColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 40)
    }
}
