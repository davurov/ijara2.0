//
//  RulesTVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit

class RulesTVC: UITableViewCell {
    
    static let identifier: String = String(describing: RulesTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    @IBOutlet weak var rulesLbl: UILabel!{
        didSet{
            rulesLbl.text = SetLanguage.setLang(type: .rules)
        }
    }
    @IBOutlet weak var collView: UICollectionView!
    var category = [Company]()
    
    //MARK: Life cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpViews() {
        collView.delegate = self
        collView.dataSource = self
        collView.register(RulesCVC.nib(), forCellWithReuseIdentifier: RulesCVC.identifier)
    }
    
}

extension RulesTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RulesCVC.identifier, for: indexPath) as! RulesCVC
        
        cell.loadImage(url: category[indexPath.row].image)
        cell.ruleLbl.text = category[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 80)
    }
}
