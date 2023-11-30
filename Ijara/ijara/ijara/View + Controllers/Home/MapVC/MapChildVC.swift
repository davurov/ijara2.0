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

protocol MapChildDelegate: AnyObject {
    func didSwipe(dir: Direction)
    func moreInfoPressed(id: Int, images: [String])
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
    
    //MARK: Variables
    
    var lottieView: LottieAnimationView?
    var houseCoordinates = (latitude: 0.0, longitude: 0.0)
    var id: Int?
    weak var delegate: MapChildDelegate?
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    let partial = screenSize.height - screenSize.height / 2
    let full = screenSize.height
    
    var images : [String] = [] {
        didSet {
            currentIndexPath.row = 0
            pageController.currentPage = 0
            configureCell()
            collView.reloadData()
        }
    }
    
    var likedHouses = {
        return UserDefaults.standard.array(forKey: Keys.likedHouses) as? [Int] ?? []
    }()
    
    var likedDates: [String] = [] {
        didSet {
            likedDates = UserDefaults.standard.stringArray(forKey: Keys.likedDate) ?? []
            print("likedDates: \(likedDates) likedHouse da")
        }
    }
    
    //MARK: life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        addSwipeRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageController.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    //MARK: function
    
    func setViews() {
        moreInfoBtn.setTitle(SetLanguage.setLang(type: .moreInfo), for: .normal)
        moreInfoBtn.titleLabel?.numberOfLines = 0
        
        contView.addShadowByHand(
            offset: CGSize(width: 0, height: 0),
            color: AppColors.customBlack.cgColor,
            radius: 5,
            opacity: 0.2
        )
        contView.layer.cornerRadius = 20
        contView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        collView.delegate = self
        collView.dataSource = self
        collView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
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
        collView.scrollRectToVisible(
            CGRect(x: 0, y: 0, width: collView.frame.width, height: collView.frame.height),
            animated: true)
    }
    
    //MARK: @IBAction functions
    
    @IBAction func moreInfoPressed(_ sender: Any) {
        delegate?.moreInfoPressed(id: id ?? 0, images: images)
    }
    
    @IBAction func directionPressed(_ sender: Any) {
        OpenMapDirections.present(in: self,latitude: houseCoordinates.latitude,longitude: houseCoordinates.longitude, sourceView: UIView())
    }
    
    @IBAction func likePressed(_ sender: Any) {
        
        guard let id = id else { return }
        
        if likedHouses.contains(id) {
            let index = likedHouses.firstIndex(of: id)
            guard let index = index else { return }
            likedHouses.remove(at: index)
            likedDates.remove(at: index)
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            likedHouses.append(id)
            likedDates.append(getCurrentDateAsString())
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        UserDefaults.standard.set(likedHouses, forKey: Keys.likedHouses)
        UserDefaults.standard.set(likedDates, forKey: Keys.likedDate)
    }
    
    func getCurrentDateAsString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let currentDate = Date()
        
        return dateFormatter.string(from: currentDate)
    }
    
    //MARK: @objc functions
    
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
    
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MapChildVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
