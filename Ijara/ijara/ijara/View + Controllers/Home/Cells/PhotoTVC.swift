//
//  PhotoTVC.swift
//  ijara
//
//  Created by Abduraxmon on 18/09/23.
//

import UIKit
import SCPageControl

class PhotoTVC: UITableViewCell {
    
    static let identifier: String = String(describing: PhotoTVC.self)
    static func nib()->UINib{return UINib(nibName: identifier, bundle: nil)}
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageController: UIView!
    
    let sc = SCPageControlView()
    var houseImgs = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func setUpViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
        
        sc.frame = pageController.bounds
        
        sc.scp_style = .SCNormal
        sc.set_view(houseImgs.count, current: 0, current_color: .white, disable_color: nil)
        
        pageController.addSubview(sc)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
extension PhotoTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseImgs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
        
        cell.loadImage(url: houseImgs[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sc.scroll_did(scrollView)
    }
    
}
