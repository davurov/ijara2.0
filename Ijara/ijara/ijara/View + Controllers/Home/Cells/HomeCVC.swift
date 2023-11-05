//
//  HomeCVC.swift
//  ijara
//
//  Created by Muslim on 28/08/23.
//

import UIKit
import SCPageControl
import SDWebImage

public enum SCPageStyle: Int {
    case SCNormal = 100
    case SCJAMoveCircle
    case SCJAFillCircle
    case SCJAFlatBar
}

protocol CellDelegate {
    func cellSelected(id: Int, images: [String], price: (working: Int, weekend:Int))
}

class HomeCVC: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel! {
        didSet {
            nameLbl.setContentHuggingPriority(.required, for: .vertical)
            nameLbl.setContentCompressionResistancePriority(.required, for: .vertical)
        }
    }
    @IBOutlet weak var priceLbl: UILabel! {
        didSet {
            priceLbl.setContentHuggingPriority(.required, for: .vertical)
            priceLbl.setContentCompressionResistancePriority(.required, for: .vertical)
            priceLbl.lineBreakMode = .byCharWrapping
        }
    }
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var imageCont: UIView!
    @IBOutlet weak var verifiedImg: UIImageView!
    @IBOutlet weak var alcoholImg: UIImageView!
    @IBOutlet weak var onlyFamilyImg: UIImageView!
    @IBOutlet weak var womenImg: UIImageView!
    @IBOutlet weak var menImg: UIImageView!
    @IBOutlet weak var mixImg: UIImageView!
    @IBOutlet weak var innirPool: UIImageView!
    @IBOutlet weak var outerPool: UIImageView!
    @IBOutlet weak var pageController: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //elements copy
    let containerView2  = UIView()
    var collectionView2 : UICollectionView!
    var pageController2 = UIView()
    let verifiedImg2    = UIImageView()
    let nameLbl2        = UILabel()
    let priceLbl2       = UILabel()
    let locationImg2    = UIImageView()
    let locationLbl2    = UILabel()
    let familyImg2      = UIImageView()
    let womens2         = UIImageView()
    let mans2           = UIImageView()
    let mixImg2         = UIImageView()
    let alcoholImg2     = UIImageView()
    
    
    var images = [String]()
    var price = (working: 0, weekend:0)
    var id = 0
    var cellDelegate: CellDelegate?
    // Home Cell Identifier
    static let identifier: String = String(describing: HomeCVC.self)
    let sc = SCPageControlView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
        setupCollView()
        setupPageController()
    }
    
    //MARK: functions
    
//    func setupViews(){
//        locationImg2 // ni setup
//        for hideViews in [containerView, imgView, nameLbl, priceLbl, locationLbl, imageCont, verifiedImg, alcoholImg, onlyFamilyImg, womenImg, meni] {
//
//        }
//    }
    
    func updateCell(id: Int, name: String, price: (workingDay: Int, weekend: Int), location: String, images: [String]){
        self.id = id
        nameLbl2.text = name
        nameLbl2.numberOfLines = 0
        priceLbl2.text = "\(price.workingDay)/\(price.weekend)"
//        priceLbl.text = "\(price.workingDay)/\(price.weekend)"
        priceLbl2.numberOfLines = 0
//        priceLbl.numberOfLines = 0
        locationLbl2.text = location
//        locationLbl.text = location
        self.images = images
    }
    
    func setupSubviews() {
        containerView2.layer.cornerRadius = 20
        containerView2.clipsToBounds = true

//        containerView.layer.cornerRadius = 20
//        containerView.clipsToBounds = true
        imageCont.layer.cornerRadius = 10
        imageCont.clipsToBounds = true
        
    }
    
    func setupPageController() {
        sc.frame = CGRect(x: 0, y: 0, width: pageController2.frame.width, height: pageController2.frame.height)
        
        sc.scp_style = .SCNormal
        sc.set_view(5, current: 0, current_color: .white, disable_color: nil)
        
        pageController2.addSubview(sc)
    }
    
    func setupCollView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView2 = UICollectionView(frame: containerView.frame, collectionViewLayout: layout)
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(PhotoCVC.nib(), forCellWithReuseIdentifier: PhotoCVC.identifier)
    }
    
    func configureCell() {
        collectionView2.scrollRectToVisible(CGRect(x: 0, y: 0, width: collectionView2.frame.width, height: collectionView2.frame.height
                                                 ), animated: true)
        collectionView2.reloadData()
    }
    
    func isVerified(v: Bool,
                    alco: Bool,
                    typeId: [Companylist],
                    pool: [Swimmingpool]) {
        
        verifiedImg2.isHidden = !v
        alcoholImg2.image = UIImage(named: "\(alco)")
//        alcoholImg.image = UIImage(named: "\(alco)")
        
        var compId = [Int]()
        
        for i in typeId {
            compId.append(i.id)
        }
        
        
        for i in 1...4 {
            if compId.contains(i) {
                switch i {
                case 1: familyImg2.isHidden = false //onlyFamilyImg.isHidden = false
                case 2: womens2.isHidden = false //womenImg.isHidden = false
                case 3: mans2.isHidden = false //menImg.isHidden = false
                case 4: mixImg2.isHidden = false //mixImg.isHidden = false
                default: break
                }
            } else {
                switch i {
                case 1: familyImg2.isHidden = true //onlyFamilyImg.isHidden = true
                case 2: womens2.isHidden = true //womenImg.isHidden = true
                case 3: mans2.isHidden = true //menImg.isHidden = true
                case 4: mixImg2.isHidden = true
                default: break
                }
            }
        }
        
        if pool.isEmpty {
            innirPool.isHidden = true
            outerPool.isHidden = true
        } else if pool.count == 1 {
            if pool[0].nsme == "Yozgi" {
                outerPool.isHidden = false
                innirPool.isHidden = true
            } else {
                innirPool.isHidden = false
                outerPool.isHidden = true
            }
        } else {
            innirPool.isHidden = false
            outerPool.isHidden = false
        }
        
    }

}

extension HomeCVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count >= 5 ? 5 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCVC.identifier, for: indexPath) as! PhotoCVC
        cell.imageCont.layer.cornerRadius = 10
        cell.loadImage(url: images[indexPath.row])
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDelegate?.cellSelected(id: id, images: images, price: price)
    }
}
