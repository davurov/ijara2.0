//
//  MapChildVC.swift
//  ijara
//
//  Created by Abduraxmon on 08/09/23.
//

import UIKit
import Lottie

enum Direction {
    case up
    case down
}

protocol MapChildDelegate {
    func didSwipe(dir: Direction)
    func moreInfoPressed(id: String, images: [String])
}

class MapChildVC: UIViewController {
    
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var houseName: UILabel!
    @IBOutlet weak var housePrice: UILabel!
    @IBOutlet weak var starLbl: UILabel!
    @IBOutlet weak var moreInfoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var animationView: UIView!
    
    var lottieView: LottieAnimationView?
    var houseCoordinates = (latitude: 0.0, longitude: 0.0)
    var id = ""
    var images : [String] = [] {
        didSet {
            currentIndexPath.row = 0
            pageController.currentPage = 0
            configureCell()
            collView.reloadData()
        }
    }
    
    var delegate: MapChildDelegate?
    var likedHouses = UserDefaults.standard.array(forKey: Keys.likedHouses) as! [String]
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    let partial = screenSize.height - screenSize.height / 2
    let full = screenSize.height

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        addSwipeRecognizer()
    }
    
    func setViews() {
        moreInfoBtn.setTitle(SetLanguage.setLang(type: .moreInfo), for: .normal)
        
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
        let swipeToUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        let swipeToDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        
        swipeToLeft.direction = .right
        swipeToRight.direction = .left
        swipeToUp.direction = .up
        swipeToDown.direction = .down
        
        collView.addGestureRecognizer(swipeToLeft)
        collView.addGestureRecognizer(swipeToRight)
        view.addGestureRecognizer(swipeToUp)
        view.addGestureRecognizer(swipeToDown)
    }
    
    func configureCell() {
        collView.scrollRectToVisible(CGRect(x: 0, y: 0, width: collView.frame.width, height: collView.frame.height
                                                 ), animated: true)
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
    
    @objc func swipeUp() {
        delegate?.didSwipe(dir: .up)
    }
    
    @objc func swipeDown() {
        delegate?.didSwipe(dir: .down)
    }
    
    @IBAction func moreInfoPressed(_ sender: Any) {
        delegate?.moreInfoPressed(id: id, images: images)
    }
    
    @IBAction func directionPressed(_ sender: Any) {
        OpenMapDirections.present(in: self,latitude: houseCoordinates.latitude,longitude: houseCoordinates.longitude, sourceView: UIView())
    }
    
    
    @IBAction func likePressed(_ sender: Any) {
        if likedHouses.contains(id) {
           let index = likedHouses.firstIndex(of: id)!
            likedHouses.remove(at: index)
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likedHouses.append(id)
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        UserDefaults.standard.set(likedHouses, forKey: Keys.likedHouses)
    }
}

extension MapChildVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count >= 5 ? 5 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
        
        cell.loadImage(url: images[indexPath.row])
        
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
