//
//  MapChildVC.swift
//  ijara
//
//  Created by Abduraxmon on 08/09/23.
//

import UIKit

class MapChildVC: UIViewController {
    
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collView: UICollectionView!
    
    var houseDM: CountryhouseData?
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    let partial = screenSize.height - screenSize.height / 2
    let full = screenSize.height

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        addSwipeRecognizer()
    }
    
    func setViews() {
        contView.addShadowByHand(offset: CGSize(width: 0, height: 0), color: AppColors.customBlack.cgColor, radius: 5, opacity: 0.2)
        contView.layer.cornerRadius = 20
        contView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        collView.delegate = self
        collView.dataSource = self
        collView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    func addSwipeRecognizer() {
        let swipeToLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe))
        let swipeToRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe))
        swipeToLeft.direction = .right
        swipeToRight.direction = .left
        self.collView.addGestureRecognizer(swipeToLeft)
        self.collView.addGestureRecognizer(swipeToRight)
    }
    
    @objc func leftSwipe() {
        if currentIndexPath.row > 0 {
            currentIndexPath.row -= 1
            collView.scrollToItem(at: currentIndexPath, at: .left, animated: true)
            pageController.currentPage = currentIndexPath.row
            collView.reloadData()
        }
    }
    
    @objc func rightSwipe() {
        if currentIndexPath.row < 4 {
            currentIndexPath.row += 1
            collView.scrollToItem(at: currentIndexPath, at: .right, animated: true)
            pageController.currentPage = currentIndexPath.row
            collView.reloadData()
        }
    }
    
}

extension MapChildVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if currentIndexPath.row == indexPath.row {
            return CGSize(width: screenSize.width - 32, height: 270)
        } else {
            return CGSize(width: 230, height: 200)
        }
    }
}
