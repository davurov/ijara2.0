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
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
        }
    }
    var isSelect = false
    
    var nums = ["1","2","3","4","5","6","8","9+"]
    override func awakeFromNib() {
        super.awakeFromNib()
       setupViews()
    }
    
    func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCVC.nib(), forCellWithReuseIdentifier: CategoryCVC.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension BedsTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCVC.identifier, for: indexPath) as! CategoryCVC
        cell.categoryNameLbl.text = nums[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
