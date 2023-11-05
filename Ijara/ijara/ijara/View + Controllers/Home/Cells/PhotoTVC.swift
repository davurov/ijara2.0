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
    @IBOutlet weak var pageCountLbl: UILabel!
    
    let sc = SCPageControlView()
    var houseImgs : [String] = [] {
        didSet {
            pageCountLbl.text = "\(currentPage)/\(houseImgs.count)"
        }
    }
    var currentPage = 1 {
        didSet {
            pageCountLbl.text = "\(currentPage)/\(houseImgs.count)"
        }
    }
    var previousOffset: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpViews()
    }
    
    func updateCell(_ images: [String]){
        houseImgs = images
    }
    
    func setUpViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
    }
    
}
//MARK: UICollectionViewDataSource
extension PhotoTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
        
        cell.loadImage(url: houseImgs[indexPath.row])
        
        return cell
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension PhotoTVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.x
        
        if currentOffset > previousOffset {
            // Swiped to the left
            if currentPage < houseImgs.count {
                currentPage += 1
            }
        } else if currentOffset < previousOffset {
            // Swiped to the right
            if currentPage > 1 {
                currentPage -= 1
            }
        }
        
        previousOffset = currentOffset
    }
}
